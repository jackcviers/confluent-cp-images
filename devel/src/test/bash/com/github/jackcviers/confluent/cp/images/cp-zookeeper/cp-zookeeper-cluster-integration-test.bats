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
		      -f ${PWD}/devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures/cluster-bridged.yml

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
    mkdir -p ./build/tmp/zookeeper-host-test/data ./build/tmp/zk-config-kitchen-sink-test/log
    local machine_private_ip=$(${BATS_BUILD_TOOL} machine ssh  hostname -I | awk '{print $1}')
    ${BATS_BUILD_TOOL} machine ssh "sudo bash -c \"grep sasl.kafka.com /etc/hosts || echo ${machine_private_ip} sasl.kafka.com >> /etc/hosts\""
    current_working_dir=$(PWD)/devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper \
		       ${docker_compose_command} \
		       up \
		       -d
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zookeeper sasl.kafka.com zookeeper-host-1)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zookeeper sasl.kafka.com zookeeper-host-2)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zookeeper sasl.kafka.com zookeeper-host-3)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zkclient sasl.kafka.com zkclient-host-1)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zkclient sasl.kafka.com zkclient-host-2)
    ${docker_compose_command} \
	exec kerberos $(kadmin_keytab_create zkclient sasl.kafka.com zkclient-host-3)
}

teardown_file(){
    ${docker_compose_command} \
	down
    ${BATS_BUILD_TOOL} machine ssh "sudo head -n -1 /etc/hosts > temp.txt ; sudo mv temp.txt /etc/hosts; cat /etc/hosts"
    rm -rf ./build/tmp/zk-config-kitchen-sink-test/data \
       ./build/tmp/zk-config-kitchen-sink-test/log
}

@test "the zookeeper-1 service should be running" {
    run ${docker_compose_command} \
	exec zookeeper-1 $(health_check sasl.kafka.com 22181)
    assert_output --partial "PASS"
}

@test "the zookeeper-2 service should be running" {
    run ${docker_compose_command} \
	exec zookeeper-1 $(health_check sasl.kafka.com 32181)
    assert_output --partial "PASS"
}

@test "the zookeeper-3 service should be running" {
    run ${docker_compose_command} \
	exec zookeeper-1 $(health_check sasl.kafka.com 42181)
    assert_output --partial "PASS"
}

@test "the zookeeper-sasl-1 service should be running" {
    run ${docker_compose_command} \
	exec zookeeper-sasl-1 $(health_check sasl.kafka.com 22182)
    assert_output --partial "PASS"
}

@test "the zookeeper-sasl-2 service should be running" {
    run ${docker_compose_command} \
	exec zookeeper-sasl-1 $(health_check sasl.kafka.com 32182)
    assert_output --partial "PASS"
}

@test "the zookeeper-sasl-3 service should be running" {
    run ${docker_compose_command} \
	exec zookeeper-sasl-1 $(health_check sasl.kafka.com 42182)
    assert_output --partial "PASS"
}

@test "the followers and leaders should be as expected without sasl" {
    local expected=("Mode: follower\n" "Mode: follower\n" "Mode: leader\n")
    local outputs=("")
    for port in 22182, 32182, 42182
    do
	outputs+=($(${BATS_BUILD_TOOL} run --network=host --rm -it --name ${BATS_IMAGE} $(mode_command ${port})))
    done
    local difference=$(diff <(printf "%s\n" "${expected[@]}") <(printf "%s\n" "${outputs[@]}"))
    run [[ -z "$difference" ]]
    assert_success
}
@test "the followers and leaders should be as expected without sasl" {
    local expected=("Mode: follower\n" "Mode: follower\n" "Mode: leader\n")
    local outputs=("")
    for port in 22182, 32182, 42182
    do
	outputs+=($(${BATS_BUILD_TOOL} run \
				       --network=host \
				       --rm \
				       -it \
				       --name cp-zookeeper-cluster-integration-test $(mode_command ${port})))
    done
    local difference=$(diff <(printf "%s\n" "${expected[@]}") <(printf "%s\n" "${outputs[@]}"))
    run [[ -z "$difference" ]]
    assert_success
}

