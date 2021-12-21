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
source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh"
source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/local/registry.sh"

@test "the registry container should launch and teardown the registry" {
    run launch_registry "${BATS_BUILD_TOOL}" "${BATS_LOCAL_REGISTRY_CONTAINER_NAME}" "${BATS_DOCKER_REGISTRY_LOCAL_PORT}"
    run ${BATS_BUILD_TOOL} ps
    assert_output --partial "${BATS_LOCAL_REGISTRY_CONTAINER_NAME}"
    run teardown_registry "${BATS_BUILD_TOOL}" "${BATS_LOCAL_REGISTRY_CONTAINER_NAME}"
    run ${BATS_BUILD_TOOL} container list -a
    refute_output --partial "${BATS_LOCAL_REGISTRY_CONTAINER_NAME}"
}

