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

COMPOSE_FILE="./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures/standalone-network.yml"

source ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/compose/helpers.sh

setup_file(){
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    assert_success
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

@test "the bridge-network service should be healthy" {
    run health_check bridge-network 2181
    assert_output --partial "PASS"
}

@test "the bridge-network service should report healthy over the network bridge" {
    run external_health_check 22181 host
    assert_output --partial "PASS"
}

@test "the host-network service should be healthy" {
    run health_check host-network 32181
    assert_output --partial "PASS"
}

@test "the host-network service should report healthy over the network bridge" {
    run external_health_check 32181 host
    assert_output --partial "PASS"
}

@test "bridge-network-jmx should be reachable by the jmx term over the network" {
    run jmx_check 2181 9999 bridge-network-jmx fixtures_zk
    assert_output --partial "Version = 3.6.3--6401e4ad2087061bc6b9f80dec2d69f2e3c8660a"
}
