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
    run ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} up -d
    run execute_on_service zookeeper-1 bash -c 'cub zk-ready zookeeper-1:2181,zookeeper-2:2181,zookeeper-3:2181 40 && echo PASS || echo FAIL'
    assert_output --partial "PASS"
}

teardown_file(){
    ${BATS_COMPOSE_TOOL} -f ${COMPOSE_FILE} down
}

