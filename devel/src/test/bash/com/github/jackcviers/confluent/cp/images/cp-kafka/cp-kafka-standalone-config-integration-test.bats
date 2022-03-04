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
    mkdir -p ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/external-volumes/data ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/kitchen-sink/data 
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    kadmin_keytab_create kafka sasl-ssl-config broker1
    assert_success
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
    rm -rf ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/external-volumes/data ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kafka/fixtures/kitchen-sink/data
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

@test "default-config kafka check should pass from kafkacat" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} run --rm -it --network=fixtures_default --name cp-kafka-standalone-default-config-kafkacat-check ${KAFKACAT_IMAGE} bash -c \"kafkacat -L -b default-config:9092 -J\" | jq -cr '.brokers[] | select(.id=\"1001\")'"
    assert_output --partial "{\"id\":1001,\"name\":\"default-config:9092\"}"
}

@test "default-config kafka log properties should be correct" {
    run execute_on_service default-config bash -c "cat /etc/kafka/log4j.properties | sort"
    assert_line --partial --index 4 "log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_line --partial --index 5 "log4j.appender.stdout.layout=org.apache.log4j.PatternLayout"
    assert_line --partial --index 6 "log4j.appender.stdout=org.apache.log4j.ConsoleAppender"
    assert_line --partial --index 7 "log4j.logger.kafka.authorizer.logger=WARN"
    assert_line --partial --index 8 "log4j.logger.kafka.controller=TRACE"
    assert_line --partial --index 9 "log4j.logger.kafka.log.LogCleaner=INFO"
    assert_line --partial --index 10 "log4j.logger.kafka.network.RequestChannel$=WARN"
    assert_line --partial --index 11 "log4j.logger.kafka.producer.async.DefaultEventHandler=DEBUG"
    assert_line --partial --index 12 "log4j.logger.kafka.request.logger=WARN"
    assert_line --partial --index 13 "log4j.logger.kafka=INFO"
    assert_line --partial --index 14 "log4j.logger.state.change.logger=TRACE"
    assert_line --partial --index 15 "log4j.rootLogger=INFO, stdout"
}

@test "default-config kafka tool log properties should be correct" {
    run execute_on_service default-config bash -c "cat cat /etc/kafka/tools-log4j.properties | sort"
    assert_line --partial --index 3 "log4j.appender.stderr.Target=System.err"
    assert_line --partial --index 4 "log4j.appender.stderr.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_line --partial --index 5 "log4j.appender.stderr.layout=org.apache.log4j.PatternLayout"
    assert_line --partial --index 6 "log4j.appender.stderr=org.apache.log4j.ConsoleAppender"
    assert_line --partial --index 7 "log4j.rootLogger=WARN, stderr"
}

@test "full-config service should be healthy" {
    run kafka_health_check full-config 9092 1 localhost
    assert_output --partial "PASS"
}

@test "full-config kafka properties sohuld be correct" {
    run execute_on_service full-config bash -c 'cat /etc/kafka/kafka.properties | sort'
    assert_line --partial --index 0 "advertised.listeners=PLAINTEXT://full-config:9092"
    assert_line --partial --index 1 "broker.id=1"
    assert_line --partial --index 2 "listeners=PLAINTEXT://0.0.0.0:9092"
    assert_line --partial --index 3 "log.dirs=/var/lib/kafka/data"
    assert_line --partial --index 4 "zookeeper.connect=zookeeper:2181/fullconfig"
}

@test "full-config kafka logging should be configured correctly" {
    run execute_on_service full-config bash -c 'cat /etc/kafka/log4j.properties | sort'
    assert_line --partial --index 4 "log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_line --partial --index 5 "log4j.appender.stdout.layout=org.apache.log4j.PatternLayout"
    assert_line --partial --index 6 "log4j.appender.stdout=org.apache.log4j.ConsoleAppender"
    assert_line --partial --index 7 "log4j.logger.kafka.authorizer.logger=WARN"
    assert_line --partial --index 8 "log4j.logger.kafka.controller=WARN"
    assert_line --partial --index 9 "log4j.logger.kafka.foo.bar=DEBUG"
    assert_line --partial --index 10 "log4j.logger.kafka.log.LogCleaner=INFO"
    assert_line --partial --index 11 "log4j.logger.kafka.network.RequestChannel$=WARN"
    assert_line --partial --index 12 "log4j.logger.kafka.producer.async.DefaultEventHandler=DEBUG"
    assert_line --partial --index 13 "log4j.logger.kafka.request.logger=WARN"
    assert_line --partial --index 14 "log4j.logger.kafka=INFO"
    assert_line --partial --index 15 "log4j.logger.state.change.logger=TRACE"
    assert_line --partial --index 16 "log4j.rootLogger=WARN, stdout"
}

@test "full-config kafak tool logging should be configured correctly" {
    run execute_on_service full-config bash -c 'cat /etc/kafka/tools-log4j.properties | sort'
    assert_line --partial --index 2 "log4j.appender.stderr.Target=System.err"
    assert_line --partial --index 3 "log4j.appender.stderr.layout.ConversionPattern=[%d] %p %m (%c)%n"
    assert_line --partial --index 4 "log4j.appender.stderr.layout=org.apache.log4j.PatternLayout"
    assert_line --partial --index 5 "log4j.appender.stderr=org.apache.log4j.ConsoleAppender"
    assert_line --partial --index 6 "log4j.rootLogger=ERROR, stderr"
}

@test "the external-volumes service should be healthy" {
    run kafka_health_check external-volumes 9092 1 localhost
    assert_output --partial "PASS"
}

@test "the random-user service should be healthy" {
    run kafka_health_check random-user 9092 1 localhost
    assert_output --partial "PASS"
}

@test "the kitchen-sink service should be healthy" {
    run kafka_health_check kitchen-sink 9092 1 localhost
    assert_output --partial "PASS"
}

@test "the kitchen-sink kafka properties should be correct" {
    run execute_on_service kitchen-sink bash -c 'cat /etc/kafka/kafka.properties | sort'
    assert_line --partial --index 0 "advertised.listeners=PLAINTEXT://kitchen-sink:9092"
    assert_line --partial --index 1 "broker.id=1"
    assert_line --partial --index 2 "confluent.support.customer.id=c0"
    assert_line --partial --index 3 "confluent.support.metrics.enable=false"
    assert_line --partial --index 4 "listeners=PLAINTEXT://0.0.0.0:9092"
    assert_line --partial --index 5 "log.dirs=/var/lib/kafka/data"
    assert_line --partial --index 6 "zookeeper.connect=zookeeper:2181/kitchensink"
}

@test "the ssl-config service should be healthy" {
    run kafka_health_check ssl-config 9092 1 ssl-config SSL
    assert_output --partial "PASS"
}

@test "the ssl-config service kafka properties should be correct" {
    run execute_on_service ssl-config bash -c "cat /etc/kafka/kafka.properties | sort"
    assert_line --partial --index 0 "advertised.listeners=SSL://ssl-config:9092"
    assert_line --partial --index 1 "broker.id=1"
    assert_line --partial --index 2 "listeners=SSL://0.0.0.0:9092"
    assert_line --partial --index 3 "log.dirs=/var/lib/kafka/data"
    assert_line --partial --index 4 "security.inter.broker.protocol=SSL"
    assert_line --partial --index 5 "ssl.key.credentials=broker1_sslkey_creds"
    assert_line --partial --index 6 "ssl.key.password=confluent"
    assert_line --partial --index 7 "ssl.keystore.credentials=broker1_keystore_creds"
    assert_line --partial --index 8 "ssl.keystore.filename=kafka.ssl-config.keystore.jks"
    assert_line --partial --index 9 "ssl.keystore.location=/etc/kafka/secrets/kafka.ssl-config.keystore.jks"
    assert_line --partial --index 10 "ssl.keystore.password=confluent"
    assert_line --partial --index 11 "ssl.truststore.credentials=broker1_truststore_creds"
    assert_line --partial --index 12 "ssl.truststore.filename=kafka.ssl-config.truststore.jks"
    assert_line --partial --index 13 "ssl.truststore.location=/etc/kafka/secrets/kafka.ssl-config.truststore.jks"
    assert_line --partial --index 14 "ssl.truststore.password=confluent"
    assert_line --partial --index 15 "zookeeper.connect=zookeeper:2181/sslconfig"
}

@test "the sasl-ssl-config service should be healthy" {
    run kafka_health_check sasl-ssl-config 9094 1 sasl-ssl-config SASL_SSL
    assert_output --partial "PASS"
}

@test "the sasl-ssl-config kafka properties should be correct" {
    run execute_on_service sasl-ssl-config bash -c "cat /etc/kafka/kafka.properties | sort"
    assert_line --partial --index 0 "advertised.listeners=SSL://sasl-ssl-config:9092,SASL_SSL://sasl-ssl-config:9094"
    assert_line --partial --index 1 "broker.id=1"
    assert_line --partial --index 2 "listeners=SSL://0.0.0.0:9092,SASL_SSL://0.0.0.0:9094"
    assert_line --partial --index 3 "log.dirs=/var/lib/kafka/data"
    assert_line --partial --index 4 "sasl.enabled.mechanisms=GSSAPI"
    assert_line --partial --index 5 "sasl.kerberos.service.name=kafka"
    assert_line --partial --index 6 "sasl.mechanism.inter.broker.protocol=GSSAPI"
    assert_line --partial --index 7 "security.inter.broker.protocol=SASL_SSL"
    assert_line --partial --index 8 "ssl.key.credentials=broker1_sslkey_creds"
    assert_line --partial --index 9 "ssl.key.password=confluent"
    assert_line --partial --index 10 "ssl.keystore.credentials=broker1_keystore_creds"
    assert_line --partial --index 11 "ssl.keystore.filename=kafka.sasl-ssl-config.keystore.jks"
    assert_line --partial --index 12 "ssl.keystore.location=/etc/kafka/secrets/kafka.sasl-ssl-config.keystore.jks"
    assert_line --partial --index 13 "ssl.keystore.password=confluent"
    assert_line --partial --index 14 "ssl.truststore.credentials=broker1_truststore_creds"
    assert_line --partial --index 15 "ssl.truststore.filename=kafka.sasl-ssl-config.truststore.jks"
    assert_line --partial --index 16 "ssl.truststore.location=/etc/kafka/secrets/kafka.sasl-ssl-config.truststore.jks"
    assert_line --partial --index 17 "ssl.truststore.password=confluent"
    assert_line --partial --index 18 "zookeeper.connect=zookeeper:2181/sslsaslconfig"
}