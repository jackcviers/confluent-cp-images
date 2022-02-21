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

COMPOSE_FILE="./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/standalone-config.yml"

source ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/compose/helpers.sh

setup_file(){
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    kadmin_keytab_create kafka sasl-ssl-config broker1
    assert_success
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

@test "zookeeper should be healthy" {
    run health_check zookeeper 2181
    assert_output --partial "PASS"
}

@test "KAFKA_ZOOKEEPER_CONNECT is required should be in the logs for failing-config-zk-connect" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-zk-connect
    assert_output --partial "KAFKA_ZOOKEEPER_CONNECT is required."
}

@test "KAFKA_ADVERTISED_LISTENERS is required should be in the logs for failing-config-adv-listeners" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-adv-listeners
    assert_output --partial "KAFKA_ADVERTISED_LISTENERS is required."
}

@test "advertised.host is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead should be in the logs of failing-config-adv-hostname" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-adv-hostname
    assert_output --partial "advertised.host is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead"
}

@test "advertised.port is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead should be in the logs of failing-config-adv-port" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-adv-port
    assert_output --partial "advertised.port is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead"
}

@test "port is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead should be in the logs of failing-config-port" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-port
    assert_output --partial "port is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead"
}

@test "host is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead should be in the logs of failing-config-host" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-host
    assert_output --partial "host is deprecated. Please use KAFKA_ADVERTISED_LISTENERS instead"
}

@test "KAFKA_SSL_KEYSTORE_FILENAME is required should be in the logs of failing-config-ssl-keystore" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-ssl-keystore
    assert_output --partial "KAFKA_SSL_KEYSTORE_FILENAME is required"
}

@test "KAFKA_SSL_KEYSTORE_CREDENTIALS is required should be in the logs of failing-config-ssl-keystore-password" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-ssl-keystore-password
    assert_output --partial "KAFKA_SSL_KEYSTORE_CREDENTIALS is required"
}

@test "KAFKA_SSL_KEY_CREDENTIALS is required should be in the logs of failing-config-ssl-key-password" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-ssl-key-password
    assert_output --partial "KAFKA_SSL_KEY_CREDENTIALS is required"
}

@test "KAFKA_OPTS is required should be in the logs of failing-config-sasl-jaas" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-sasl-jaas
    assert_output --partial "KAFKA_OPTS is required"
}

@test "KAFKA_OPTS should contain 'java.security.auth.login.config' property should be in the logs of failing-config-sasl-missing-prop" {
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} logs failing-config-sasl-missing-prop
    assert_output --partial "KAFKA_OPTS should contain 'java.security.auth.login.config' property"
}

@test "default-config service should be healthy" {
    run kafka_health_check default-config 9092 1 localhost
    assert_output --partial "PASS"
}

@test "the default-config kafka.properties should be correct" {
    run execute_on_service default-config bash -c "cat /etc/kafka/kafka.properties | sort"
    assert_line --partial --index 0 "advertised.listeners=PLAINTEXT://default-config:9092"
    assert_line --partial --index 1 "listeners=PLAINTEXT://0.0.0.0:9092"
    assert_line --partial --index 2 "log.dirs=/var/lib/kafka/data"
    assert_line --partial --index 3 "zookeeper.connect=zookeeper:2181/defaultconfig"
}
