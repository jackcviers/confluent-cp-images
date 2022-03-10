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

setup_file(){
    $BATS_BUILD_TOOL run -d --platform=linux/$ARCH --name cp-kafka-test-${ARCH} ${BATS_IMAGE} tail -f /dev/null
}

teardown_file(){
    container=cp-kafka-test-${ARCH}
    $BATS_BUILD_TOOL stop -t 2 ${container}
    $BATS_BUILD_TOOL container rm ${container} 3>&-
}

@test "the software-properties-common package should be installed" {
    run unbuffer $BATS_BUILD_TOOL exec -it cp-kafka-test-${ARCH} apt list software-properties-common --installed
    assert_output --partial "software-properties-common"
}

@test "the confluent-kafka package should be installed" {
    run unbuffer $BATS_BUILD_TOOL exec -it cp-kafka-test-${ARCH} apt list confluent-kafka --installed
    assert_output --partial "confluent-kafka"
}

@test "/var/lib/kafka should exist and be owned by appuser:root" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /var/lib/kafka
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /var/lib/kafka
    assert_output --partial "root"
}

@test "/etc/kafka should exist and be owned by appuser:root" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/kafka
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/kafka
    assert_output --partial "root"
}

@test "/etc/kafka/secrets should exist and be owned by appuser:root" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/kafka/secrets
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/kafka/secrets
    assert_output --partial "root"
}

@test "/var/log/kafka should exist and be owned by appuser:root" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /var/log/kafka
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /var/log/kafka
    assert_output --partial "root"
}

@test "/var/log/confluent should exist and be owned by appuser:root" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /var/log/confluent
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /var/log/confluent
    assert_output --partial "root"
}

@test "/var/lib/zookeeper should exist and be owned by appuser:root" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /var/lib/zookeeper
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /var/lib/zookeeper
    assert_output --partial "root"
}

@test "/var/run/krb5 should exist and be owned by appuser:root" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /var/run/krb5
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /var/run/krb5
    assert_output --partial "root"
}

@test "/var/lib/kafka should have 776 permissions" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} ls -al /var/lib/kafka
    assert_output --partial "drwxrwxrwx"
}

@test "/etc/kafka should have 776 permissions" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} ls -al /etc/kafka
    assert_output --partial "drwxrwxrwx"
}

@test "/var/log/kafka should have 776 permissions" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} ls -al /var/log/kafka
    assert_output --partial "drwxrwxrwx"
}

@test "/var/log/confluent should have 776 permissions" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} ls -al /var/log/confluent
    assert_output --partial "drwxrwxrwx"
}

@test "/var/lib/zookeeper should have 777 permissions" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} ls -al /var/lib/zookeeper
    assert_output --partial "drwxrwxrwx"
}

@test "/var/run/krb5 should have 777 permissions" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} ls -al /var/run/krb5
    assert_output --partial "drwxrwxrwx"
}

@test "/etc/confluent/docker/configure should exist owned by appuser:appuser" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/confluent/docker/configure
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/confluent/docker/configure
    assert_output --partial "appuser"
}

@test "/etc/confluent/docker/ensure should exist owned by appuser:appuser" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/confluent/docker/ensure
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/confluent/docker/ensure
    assert_output --partial "appuser"
}

@test "/etc/confluent/docker/kafka.properties.template should exist owned by appuser:appuser" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/confluent/docker/kafka.properties.template
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/confluent/docker/kafka.properties.template
    assert_output --partial "appuser"
}

@test "/etc/confluent/docker/launch should exist owned by appuser:appuser" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/confluent/docker/launch
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/confluent/docker/launch
    assert_output --partial "appuser"
}

@test "/etc/confluent/docker/log4j.properties.template should exist owned by appuser:appuser" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/confluent/docker/log4j.properties.template
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/confluent/docker/log4j.properties.template
    assert_output --partial "appuser"
}

@test "/etc/confluent/docker/run should exist owned by appuser:appuser" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/confluent/docker/run
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/confluent/docker/run
    assert_output --partial "appuser"
}

@test "/etc/confluent/docker/tools-log4j.properties.template should exist owned by appuser:appuser" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%U' /etc/confluent/docker/tools-log4j.properties.template
    assert_output --partial "appuser"
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafka-test-${ARCH} stat -c '%G' /etc/confluent/docker/tools-log4j.properties.template
    assert_output --partial "appuser"
}

@test "/var/lib/kafka/data should be a volume" {
      run unbuffer bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -c '.[0].Config.Volumes'"
      assert_output --partial "/var/lib/kafka/data"
}

@test "/etc/kafka/secrets should be a volume" {
      run unbuffer bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -c '.[0].Config.Volumes'"
      assert_output --partial "/etc/kafka/secrets"
}

@test "/var/run/krb5 should be a volume" {
      run unbuffer bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -c '.[0].Config.Volumes'"
      assert_output --partial "/var/run/krb5"
}


@test "whoami should be appuser" {
    run unbuffer bash -c "$BATS_BUILD_TOOL exec -it cp-kafka-test-${ARCH} whoami" 3>&-
    assert_output --partial "appuser"
}

@test "pwd should be /home/appuser/" {
    run unbuffer bash -c "$BATS_BUILD_TOOL exec -it cp-kafka-test-${ARCH} pwd" 3>&-
    assert_output --partial "/home/appuser"
}

@test "cmd should be /etc/confluent/docker/run" {
    run bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Cmd | .[0]'"
    assert_output "/etc/confluent/docker/run"
}

