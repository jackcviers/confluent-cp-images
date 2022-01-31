#!/usr/bin/env bats

# Copyright 2022 Jack Viers

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load "${BATS_LIBS_INSTALL_LOCATION}/bats-support/load.bash"
load "${BATS_LIBS_INSTALL_LOCATION}/bats-assert/load.bash"

docker_compose_command=docker-comopose \
		      -f ${PWD}/devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures/standalone-config.yml

kadmin_keytab_create(){
    principal=$1
    hostname=$2
    filename=$3
    cat <<-EOF
kadmin.local -q "addprinc -randkey ${principal}/${hostname}@TEST.CONFLUENT.IO" && \
        kadmin.local -q "ktadd -norandkey -k /tmp/keytab/${filename}.keytab ${principal}/${hostname}@TEST.CONFLUENT.IO"
EOF
}

health_check(){
    client_port=$1
    host=$2
    echo "cub zk-ready ${host}:${port} 30 && echo PASS || echo FAIL"
}

setup_file(){
    current_working_dir=$(PWD) \
		       ${docker_compose_command} \
		       up \
		       -d
    mkdir -p ./build/tmp/zk-config-kitchen-sink-test/data ./build/tmp/zk-config-kitchen-sink-test/log
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zookeeper sasl-config zookeeper-config)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zkclient sasl-config zkclient-config)
}

teardown_file(){
    ${docker_compose_command} \
	down
}

@test "zookeeper should be healthy using the default configuration" {
    run ${docker_compose_command} \
	exec default-config $(health_check localhost 2181)
    assert_output --partial "PASS"    
}

@test "default-configuration /etc/kafka/zookeeper.properties should be correct" {
    run ${docker_compose_command} \
	exec default-config cat /etc/kafka/zookeeper.properties
    assert_output --partial "clientPort=2181"
    assert_output --partial "dataDir=/var/lib/zookeeper/data"
    assert_output --partial "dataLogDir=/var/lib/zookeeper/log"
}

@test "when ZOOKEEPER_CLIENT_PORT is unspecified, 'ZOOKEEPER_CLIENT_PORT is required' should appear in the logs" {
    run ${docker_compose_command} \
	logs failing-config
    assert_output --partial "ZOOKEEPER_CLIENT_PORT is required"
}

@test "when ZOOKEEPER_SERVER_ID is unspecified, 'ZOOKEEPER_SERVER_ID is required' should appear in the logs" {
    run ${docker_compose_command} \
	logs failing-config
    assert_output --partial "ZOOKEEPER_SERVER_ID is required"
}

@test "/etc/kafka/log4j.properties should be correct on the default-config service" {
    run ${docker_compose_command} \
	exec default-config cat /etc/kafka/log4j.properties
    assert_output --partial "log4j.rootLogger=INFO, stdout"
    assert_output --partial \
		  "log4j.appender.stdout=org.apache.log4j.ConsoleAppender"
    assert_output --partial \
		  "log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n"
}

@test "/etc/kafka/tools-log4j.properties should be correct on the default-config service" {
    run ${docker_compose_command} \
	exec default-config cat /etc/kafka/tools-log4j.properties
    assert_output --partial "log4j.rootLogger=WARN, stderr"
    assert_output --partial "log4j.appender.stderr=org.apache.log4j.ConsoleAppender"
    assert_output --partial "log4j.appender.stderr.layout=org.apache.log4j.PatternLayout"
    assert_output --partial "log4j.appender.stderr.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_output --partial "log4j.appender.stderr.Target=System.err"
}

@test "the full-config service should be healthy" {
    run ${docker_compose_command} \
	exec full-config $(health_check localhost 22181)
    assert_output --partial "PASS"    
}

@test "the full-config service /etc/kafka/zookeeper.properties should be correct" {
    run ${docker_compose_command} \
	exec full-config cat /etc/kafka/zookeeper.properties
    assert_output --partial "clientPort=22181"
    assert_output --partial "dataDir=/var/lib/zookeeper/data"
    assert_output --partial "dataLogDir=/var/lib/zookeeper/log"
    assert_output --partial "initLimit=25"
    assert_output --partial "autopurge.purgeInterval=2"
    assert_output --partial "syncLimit=20"
    assert_output --partial "autopurge.snapRetainCount=4"
    assert_output --partial "tickTime=5555"
    assert_output --partial "quorumListenOnAllIPs=false"
}

@test "the full-config service /etc/kafka/log4j.properties should be correct" {
    run ${docker_compose_command} \
	exec full-config cat /etc/kafka/log4j.properties
    assert_output --partial "log4j.rootLogger=WARN, stdout"
    assert_output --partial \
		  "log4j.appender.stdout=org.apache.log4j.ConsoleAppender"
    assert_output --partial \
		  "log4j.appender.stdout.layout=org.apache.log4j.PatternLayout"
    assert_output --partial \
		  "log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_output --partial "log4j.logger.zookeeper.foo.bar=DEBUG, stdout"
}

@test "the full-config service /etc/kafka/tools-log4j.properties should be correct" {
    run ${docker_compose_command} \
	exec full-config cat /etc/kafka/tools-log4j.properties
    assert_output --partial "log4j.rootLogger=ERROR, stderr"
    assert_output --partial \
		  "log4j.appender.stderr=org.apache.log4j.ConsoleAppender"
    assert_output --partial \
		  "log4j.appender.stderr.layout=org.apache.log4j.PatternLayout"
    assert_output --partial \
		  "log4j.appender.stderr.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_output --partial "log4j.appender.stderr.Target=System.err"
}

@test "the external-volumes service should be healthy" {
    run ${docker_compose_command} \
	exec external-volumes $(health_check localhost 2181)
    assert_output --partial "PASS"    
}

@test "the sasl-config service should be healthy" {
    run ${docker_compose_command} \
	exec sasl-config $(health_check sasl-config 52181)
    assert_output --partial "PASS"    
}

@test "the random-user service should be healthy" {
    run ${docker_compose_command} \
	exec random-user $(health_check localhost 2181)
    assert_output --partial "PASS"    
}

@test "the kitchen-sink service should be healthy" {
    run ${docker_compose_command} \
	exec kitchen-sink $(health_check localhost 22181)
    assert_output --partial "PASS"    
}

@test "the kitchen-sink /etc/kafka/zookeeper.properties should be correct" {
    run ${docker_compose_command} \
	exec full-config cat /etc/kafka/zookeeper.properties
    assert_output --partial "clientPort=22181"
    assert_output --partial "dataDir=/var/lib/zookeeper/data"
    assert_output --partial "dataLogDir=/var/lib/zookeeper/log"
    assert_output --partial "initLimit=25"
    assert_output --partial "syncLimit=20"
    assert_output --partial "tickTime=5555"
    assert_output --partial "quorumListenOnAllIPs=false"
    assert_output --partial "quorumListenOnAllIPs=false"
}

@test "the kitchen-sink /var/lib/zookeeper/data/myid should be 1" {
    run ${docker_compose_command} \
	exec full-config cat /var/lib/zookeeper/data/myid
    assert_output --partial "1"
}
