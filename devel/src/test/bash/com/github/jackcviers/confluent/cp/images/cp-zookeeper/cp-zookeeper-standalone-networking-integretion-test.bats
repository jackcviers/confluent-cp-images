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
		      -f ${PWD}/devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures/standalone-network.yml

health_check(){
    client_port=$1
    host=$2
    echo "cub zk-ready ${host}:${port} 30 && echo PASS || echo FAIL"
}

setup_file(){
    ${docker_compose_command} \
	up \
	-d
}

teardown_file(){
    ${docker_compose_command} \
	down
}

@test "zookeeper on bridge network driver should be accessible from within the container" {
    run ${docker_compose_command} \
	exec bridge-network $(health_check localhost 2181)
    assert_output --partial "PASS"
}

@test "zookeeper on bridge network driver should be accessible from outside the containe" {
    run ${BATS_BUILD_TOOL} run --rm -it --name cp-zookeeper-bridge-network-test ${BATS_IMAGE} --network=host $(health_check localhost 22181)
    assert_output --partial "PASS"
}

@test "zookeeper on host network driver should be accessible from within the container" {
    run ${docker_compose_command} \
	exec host-network $(health_check localhost 32181)
    assert_output --partial "PASS"
}

@test "zookeeper on host network driver should be accessible from outside the container" {
    run ${BATS_BUILD_TOOL} run --rm -it --name cp-zookeeper-bridge-network-test ${BATS_IMAGE} --network=host $(health_check localhost 32181)
    assert_output --partial "PASS"
}


