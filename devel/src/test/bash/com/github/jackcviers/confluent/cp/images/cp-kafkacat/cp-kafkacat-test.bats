#!/usr/bin/env bats

# Copyright 2021 Jack Viers

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
    $BATS_BUILD_TOOL run -d --platform=linux/$ARCH --name cp-kafkacat-test-${ARCH} ${BATS_IMAGE} tail -f /dev/null
}

teardown_file(){
    container=cp-kafkacat-test-${ARCH}
    $BATS_BUILD_TOOL stop -t 2 ${container}
    $BATS_BUILD_TOOL container rm ${container} 3>&-
}

@test "kafkacat should be installed" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kafkacat-test-${ARCH} apt list kafkacat --installed
    assert_output --partial "kafkacat"
}
