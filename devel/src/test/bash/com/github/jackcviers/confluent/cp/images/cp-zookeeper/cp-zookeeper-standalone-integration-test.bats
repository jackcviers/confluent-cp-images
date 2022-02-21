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

COMPOSE_FILE="./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures/standalone-config.yml"

source ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/compose/helpers.sh

setup_file(){
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    kadmin_keytab_create zookeeper sasl-config zookeeper-config
    kadmin_keytab_create zkclient sasl-config zkclient-config
    kadmin_keytab_create krbtgt TEST.CONFLUENT.IO zkclient-config
    assert_success
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

@test "default config should be healthy" {
    run health_check default-config 2181
    assert_output --partial "PASS"
}

@test "the default configuration zookeeper.properties file should be correct" {
    run execute_on_service default-config cat /etc/kafka/zookeeper.properties
    assert_output --partial "clientPort=2181"
    assert_output --partial "dataDir=/var/lib/zookeeper/data"
    assert_output --partial "dataLogDir=/var/lib/zookeeper/log"
}

@test "the default configuration logging configuration should be correct" {
    run execute_on_service default-config cat /etc/kafka/tools-log4j.properties
    assert_output --partial "log4j.rootLogger=WARN, stderr"
    assert_output --partial "log4j.appender.stderr=org.apache.log4j.ConsoleAppender"
    assert_output --partial "log4j.appender.stderr.layout=org.apache.log4j.PatternLayout"
    assert_output --partial "log4j.appender.stderr.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_output --partial "log4j.appender.stderr.Target=System.err"
}

@test "the full-config should be healthy" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it fixtures_full-config_1 bash -c "cub zk-ready localhost:22181 30 && echo PASS || echo FAIL"
    assert_output --partial "PASS"
}

@test "the zookeeper.properties file for the full-config should be correct" {
    run execute_on_service full-config cat /etc/kafka/zookeeper.properties
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

@test "the full-config zookeeper id should be 1" {
    run execute_on_service full-config cat /var/lib/zookeeper/data/myid
    assert_output --partial "1"
}

@test "the full-config logging configuration should be correct" {
    run execute_on_service full-config cat /etc/kafka/log4j.properties
    assert_output --partial "log4j.rootLogger=WARN, stdout"
    assert_output --partial "log4j.appender.stdout=org.apache.log4j.ConsoleAppender"
    assert_output --partial "log4j.appender.stdout.layout=org.apache.log4j.PatternLayout"
    assert_output --partial "log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_output --partial "log4j.logger.zookeeper.foo.bar=DEBUG, stdout"
}

@test "the external-volumes service should be healthy" {
    run health_check external-volumes 2181
    assert_output --partial "PASS"
}

@test "the sasl-config service should be healthy" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it fixtures_full-config_1 bash -c "cub zk-ready sasl-config:52181 30 && echo PASS"
    assert_output --partial "PASS"
}

@test "the random-user service should be healthy" {
    run unbuffer ${BATS_BUILD_TOOL} exec --user root -it fixtures_random-user_1 bash -c "cub zk-ready localhost:2181 60 && echo PASS || echo FAIL"
    assert_output --partial "PASS"
}

@test "the kitchen-sink service should be healthy" {
    run unbuffer ${BATS_BUILD_TOOL} exec --user root -it fixtures_kitchen-sink_1 bash -c "cub zk-ready localhost:22181 60 && echo PASS || echo FAIL"
    assert_output --partial "PASS"
}

@test "the kitchen-sink service zookeeper properties should be correct" {
    run execute_on_service kitchen-sink cat /etc/kafka/zookeeper.properties
    assert_output --partial "clientPort=22181"
    assert_output --partial "dataDir=/var/lib/zookeeper/data"
    assert_output --partial "dataLogDir=/var/lib/zookeeper/log"
    assert_output --partial "initLimit=25"
    assert_output --partial "syncLimit=20"
    assert_output --partial "tickTime=5555"
    assert_output --partial "quorumListenOnAllIPs=false"
}

@test "the kitchen-sink service zookeeper id should be correct" {
    run execute_on_service kitchen-sink cat /var/lib/zookeeper/data/myid
    assert_output --partial "1"
}
