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

COMPOSE_FILE="./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/standalone-networking.yml"

source ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/compose/helpers.sh

setup_file(){
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    assert_success
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

@test "the zookeeper-bridge service should be healthy" {
    run health_check zookeeper-bridge 2181
    assert_output --partial "PASS"
}

@test "the zookeeper-hest service should be healthy" {
    run health_check zookeeper-host 32181
    assert_output --partial "PASS"
}

@test "kafka-bridge should be healthy" {
    run kafka_health_check kafka-bridge 19092 1 localhost
    assert_output --partial "PASS"
}

@test "kafkacat should report healthy for locolhost 19092" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=host --name cp-kafka-standalone-19092-kafkacat-check ${KAFKACAT_IMAGE} bash -c \"kafkacat -L -b localhost:19092 -J\" | jq -cr '.brokers[] | select(.id=\"1\")'"
    assert_output --partial "{\"id\":1,\"name\":\"localhost:19092\"}"
}

@test "kafka-host service should be healthy" {
    run kafka_health_check kafka-host 29092 1 localhost
    assert_output --partial "PASS"
}

@test "kafkacat should report healthy for localhost 29092" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=host --name cp-kafka-standalone-29092-kafkacat-check ${KAFKACAT_IMAGE} bash -c \"kafkacat -L -b localhost:29092 -J\" | jq -cr '.brokers[] | select(.id=\"1\")'"
    assert_output --partial "{\"id\":1,\"name\":\"localhost:29092\"}"
}


