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

COMPOSE_FILE="./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/cluster-bridged-plain.yml"

source ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/compose/helpers.sh

setup_file(){
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    assert_success
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

@test "zookeeper-1 should be healthy" {
    run execute_on_service zookeeper-1 bash -c 'cub zk-ready zookeeper-1:2181,zookeeper-2:2181,zookeeper-3:2181 40 && echo PASS || echo FAIL'
    assert_output --partial "PASS"
}

@test "kafka-1 service should be healthy" {
    run kafka_health_check kafka-1 9092 3 localhost
    assert_output --partial "PASS"
}

@test "kafkacat should report healthy for kafka 1-3 services" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=fixtures_zk --name cp-kafka-bridged-plain-1-3-kafkacat-check ${KAFKACAT_IMAGE} bash -c \"kafkacat -L -b kafka-1:9092 -J\" | jq -cr '.brokers[] | select(.id == 1)'"
    assert_output --partial "{\"id\":1,\"name\":\"kafka-1:9092\"}"
    run bash -c "unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=fixtures_zk --name cp-kafka-bridged-plain-1-3-kafkacat-check ${KAFKACAT_IMAGE} bash -c \"kafkacat -L -b kafka-1:9092 -J\" | jq -cr '.brokers[] | select(.id == 2)'"
    assert_output --partial "{\"id\":2,\"name\":\"kafka-2:9092\"}"
    run bash -c "unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=fixtures_zk --name cp-kafka-bridged-plain-1-3-kafkacat-check ${KAFKACAT_IMAGE} bash -c \"kafkacat -L -b kafka-1:9092 -J\" | jq -cr '.brokers[] | select(.id == 3)'"
    assert_output --partial "{\"id\":3,\"name\":\"kafka-3:9092\"}"
}

@test "the kafka producer should produce 100 messages to kafka-1" {
    run produce_n_plain_messages foo "kafka-1:9092" 100 \
	fixtures_zk "zookeeper-1:2181,zookeeper-2:2181,zookeeper-3:2181"
    assert_output --partial "Processed a total of 100 messages"
}
