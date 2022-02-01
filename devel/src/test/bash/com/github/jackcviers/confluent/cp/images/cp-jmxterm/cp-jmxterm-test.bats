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
    $BATS_BUILD_TOOL run -d -t --arch=$ARCH --name cp-jmxterm-test-${ARCH} ${BATS_IMAGE} tail -f /dev/null
}

teardown_file(){
    container=cp-jmxterm-test-${ARCH}
    $BATS_BUILD_TOOL stop -t 2 ${container}
    $BATS_BUILD_TOOL container rm ${container}
}

@test "/opt/jmxterm-1.0.1-uber.jar should be installed" {
    run bash -c "$BATS_BUILD_TOOL exec -it cp-jmxterm-test-${ARCH} test -f /opt/jmxterm-1.0.1-uber.jar"
    assert_success
}

@test "whoami should be appuser" {
    run bash -c "$BATS_BUILD_TOOL exec -it cp-jmxterm-test-${ARCH} whoami" 3>&-
    assert_output --partial "appuser"
}

@test "pwd should be /home/appuser/" {
    run bash -c "$BATS_BUILD_TOOL exec -it cp-jmxterm-test-${ARCH} pwd" 3>&-
    assert_output --partial "/home/appuser"
}


