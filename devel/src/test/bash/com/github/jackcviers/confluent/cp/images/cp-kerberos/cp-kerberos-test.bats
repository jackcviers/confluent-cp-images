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
    $BATS_BUILD_TOOL run -d -t --arch=$ARCH --name cp-kerberos-test-${ARCH} ${BATS_IMAGE} tail -f /dev/null
}

teardown_file(){
    container=cp-kerberos-test-${ARCH}
    $BATS_BUILD_TOOL stop -t 2 ${container}
    $BATS_BUILD_TOOL container rm ${container}
}

@test "krb5-server, krb5-libs, and krb5-workstation should be installed" {
    run bash -c "$BATS_BUILD_TOOL exec -it cp-kerberos-test-${ARCH} yum list --installed"
    assert_output --partial "krb5-server"
    assert_output --partial "krb5-libs"
    assert_output --partial "krb5-workstation"
}

@test "config.sh should exist" {
    run bash -c "$BATS_BUILD_TOOL exec -it cp-kerberos-test-${ARCH} [ -f config.sh ]"
    assert_success    
}

@test "config.sh should be the entrypoint" {
    run bash -c "$BATS_BUILD_TOOL inspect cp-kerberos-test-${ARCH} | jq -cr '.[0].Config.Entrypoint'"
    assert_output "/config.sh"
}
