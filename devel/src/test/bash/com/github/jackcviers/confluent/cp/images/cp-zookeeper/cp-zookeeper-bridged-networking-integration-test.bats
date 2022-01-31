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

docker_compose_command="docker-comopose -f ${PWD}/devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures/cluster-bridged.yml"

kadmin_keytab_create(){
    local principal=$1
    local hostname=$2
    local filename=$3
    cat <<-EOF
kadmin.local -q "addprinc -randkey ${principal}/${hostname}@TEST.CONFLUENT.IO" && \
        kadmin.local -q "ktadd -norandkey -k /tmp/keytab/${filename}.keytab ${principal}/${hostname}@TEST.CONFLUENT.IO"
EOF
}

health_check(){
    local client_port=$1
    local host=$2
    echo "cub zk-ready ${host}:${port} 30 && echo PASS || echo FAIL"
}

mode_command(){
    local port=$1
    echo "bash -c 'dub wait localhost ${port} 30 && echo stat | nc localhost ${port} | grep Mode'"
}

setup_file(){
    mkdir -p ./build/tmp/zk-config-kitchen-sink-test/data ./build/tmp/zk-config-kitchen-sink-test/log
    current_working_dir=$(PWD)/devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures \
		       ${docker_compose_command} \
		       up \
		       -d
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zookeeper zookeeper-sasl-1 zookeeper-bridged-1)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zookeeper zookeeper-sasl-2 zookeeper-bridged-2)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zookeeper zookeeper-sasl-3 zookeeper-bridged-3)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zkclient zookeeper-sasl-1 zkclient-bridged-1)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zkclient zookeeper-sasl-2 zkclient-bridged-2)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zkclient zookeeper-sasl-3 zkclient-bridged-3)
}

teardown_file(){
    ${docker_compose_command} \
	down
    rm -rf ./build/tmp/zk-config-kitchen-sink-test/data \
       ./build/tmp/zk-config-kitchen-sink-test/log
}

@test "zookeeper-1, zookeeper-2, kerberos, zookeeper-sasl-1, zookeeper-sasl-2, and zookeeper-sasl-3 should be running" {
    for service in zookeeper-1 zookeeper-2 kerberos zookeeper-sasl-1 zookeeper-sasl-2 zookeeper-sasl-3
    do
	run \
	    bash \
	    -c "[ -z `docker ps -q --no-trunc \
                  | grep $(docker-compose ps -q ${service})` ]"
	assert_success
    done	
}

@test "zookeeper should be running on all hosts" {
    for host in zookeeper-1 zookeeper-1 zookeeper-3
    do
	run ${docker_compose_command} \
	    exec zookeeper-1 $(health_check ${host} 2181)
	assert_output --partial "PASS"
    done
}

@test "zookeeper should be reachable by mapped ports" {
    local expected=("Mode: follower\n" "Mode: follower\n" "Mode: leader\n")
    local outputs=("")
    for port in 22181 32181 42181
    do
	outputs+=($(${BATS_BUILD_TOOL} run \
				       --rm \
				       -it \
				       --network=host \
				       --name cp-zookeeper-bridged-networking-integration-test \
				       $(mode_command ${port})))
    done
    local difference=$(diff <(printf "%s\n" "${expected[@]}") <(printf "%s\n" "${outputs[@]}"))
    run [[ -z "$difference" ]]
    assert_success
}

@test "sasl services should be running for zookeeper-sasl-1, zookeeper-sasl-2 and zookeeper-sasl-3" {
    for service in zookeeper-sasl-1, zookeeper-sasl-2 zookeeper-sasl-3
    do
	run ${docker_compose_command} \
	    exec ${service} $(health_check ${service} 2181)
	assert_output --partial "PASS"
    done
}

