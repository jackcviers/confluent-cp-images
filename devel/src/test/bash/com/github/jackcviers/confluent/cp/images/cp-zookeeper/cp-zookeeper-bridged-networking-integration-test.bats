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

COMPOSE_FILE="./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-zookeeper/fixtures/cluster-bridged.yml"

source ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/compose/helpers.sh

setup_file(){
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    kadmin_keytab_create zookeeper zookeeper-sasl-1 zookeeper-bridged-1
    kadmin_keytab_create zookeeper zookeeper-sasl-2 zookeeper-bridged-2
    kadmin_keytab_create zookeeper zookeeper-sasl-3 zookeeper-bridged-3
    kadmin_keytab_create zkclient zookeeper-sasl-1 zkclient-bridged-1
    kadmin_keytab_create zkclient zookeeper-sasl-2 zkclient-bridged-2
    kadmin_keytab_create zkclient zookeeper-sasl-3 zkclient-bridged-3
    assert_success
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

@test "zookeeper-1 should be healthy" {
    run health_check zookeeper-1 2181 zookeeper-1
    assert_output --partial "PASS"
}
@test "zookeeper-2 should be healthy" {
    run health_check zookeeper-1 2181 zookeeper-2
    assert_output --partial "PASS"
}
@test "zookeeper-3 should be healthy" {
    run health_check zookeeper-1 2181 zookeeper-3
    assert_output --partial "PASS"
}

@test "the open cluster should have 22181->follower, 32181->follower, 42181->leader" {

    run ${BATS_BUILD_TOOL} run --rm --network=host ${BATS_IMAGE} bash -c "dub wait localhost 22181 30 && echo stat | nc localhost 22181 | grep Mode"
    assert_output --partial "Mode: follower"
    run ${BATS_BUILD_TOOL} run --rm --network=host ${BATS_IMAGE} bash -c "dub wait localhost 32181 30 && echo stat | nc localhost 32181 | grep Mode"
    assert_output --partial "Mode: follower"
    run ${BATS_BUILD_TOOL} run --rm --network=host ${BATS_IMAGE} bash -c "dub wait localhost 42181 30 && echo stat | nc localhost 42181 | grep Mode"
    assert_output --partial "Mode: leader"
}

@test "zookeeper-sasl-1 should be healthy" {
    run health_check zookeeper-sasl-1 2181 zookeeper-sasl-1
    assert_output --partial "PASS"
}

@test "zookeeper-sasl-2 should be healthy" {
    run health_check zookeeper-sasl-2 2181 zookeeper-sasl-2
    assert_output --partial "PASS"
}

@test "zookeeper-sasl-3 should be healthy" {
    run health_check zookeeper-sasl-3 2181 zookeeper-sasl-3
    assert_output --partial "PASS"
}



