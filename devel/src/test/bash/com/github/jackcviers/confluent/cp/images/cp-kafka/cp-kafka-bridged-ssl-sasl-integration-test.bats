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

COMPOSE_FILE="./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/cluster-bridged-ssl-sasl.yml"

source ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/compose/helpers.sh

setup_file(){
    cd ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/secrets/
    ./create-certs.sh
    cd -
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    kadmin_keytab_create kafka kafka-sasl-ssl-1 bridged_broker1
    kadmin_keytab_create kafka kafka-sasl-ssl-2 bridged_broker2
    kadmin_keytab_create kafka kafka-sasl-ssl-3 bridged_broker3
    kadmin_keytab_create bridged_kafkacat bridged_kafkacat bridged_kafkacat
    kadmin_keytab_create bridged_producer kafka-sasl-ssl-producer bridged_producer
    kadmin_keytab_create bridged_consumer kafka-sasl-ssl-consumer bridged_consumer
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d kafka-sasl-ssl-1 kafka-sasl-ssl-2 kafka-sasl-ssl-3
    sleep 60
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

@test "kafka is healthy" {
    run kafka_health_check kafka-sasl-ssl-1 9094 3 kafka-sasl-ssl-1 SASL_SSL
    assert_output --partial "PASS"
}


@test "the kafka producer should produce 100 messages" {
    run execute_on_service kafka-producer-ssl bash -c 'kafka-topics --command-config /etc/kafka/secrets/bridged.producer.ssl.sasl.config --bootstrap-server kafka-sasl-ssl-1:9094,kafka-sasl-ssl-2:9094,kafka-sasl-ssl-3:9094 --create --topic foo --partitions 1 --replication-factor 3 --if-not-exists && seq 100 | kafka-console-producer --bootstrap-server kafka-sasl-ssl-1:9094,kafka-sasl-ssl-2:9094,kafka-sasl-ssl-3:9094 --topic foo --producer.config /etc/kafka/secrets/bridged.producer.ssl.sasl.config && seq 100 | kafka-console-producer --bootstrap-server kafka-sasl-ssl-1:9094,kafka-sasl-ssl-2:9094,kafka-sasl-ssl-3:9094 --topic foo --producer.config /etc/kafka/secrets/bridged.producer.ssl.sasl.config && echo "PRODUCED 100 messages."'
    assert_output --partial "PRODUCED 100 messages."
}




