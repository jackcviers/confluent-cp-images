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
    $BATS_BUILD_TOOL run -d -t --arch=$ARCH --name cp-zookeeper-test-${ARCH} ${BATS_IMAGE} tail -f /dev/null
     echo "STATUS: $?"
}

teardown_file(){
    container=cp-zookeeper-test-${ARCH}
    $BATS_BUILD_TOOL stop -t 2 ${container}
    $BATS_BUILD_TOOL container rm ${container} 3>&-
}

@test "/var/lib/zookeeper should be owned by appuser:root" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/var/lib/zookeeper\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/var/lib/zookeeper\""
    assert_output --partial "root"
}

@test "package confluent-kafka should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "apt list confluent-kafka --installed" 3>&-
    assert_output --partial "confluent-kafka"
}

@test "/var/lib/zookeeper/data should exist" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "[ -d \"/var/lib/zookeeper/data\" ]" 3>&-
    assert_success
}

@test "/var/lib/zookeeper/data should be owned by appuser:root and have 775 permissions" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/var/lib/zookeeper/data\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/var/lib/zookeeper/data\""
    assert_output --partial "root"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "ls -ld /var/lib/zookeeper/data"
    assert_output --partial "drwxrwxr-x."
}

@test "/var/lib/zookeeper/log should be owned by appuser:root and have 775 permissions" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/var/lib/zookeeper/log\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/var/lib/zookeeper/log\""
    assert_output --partial "root"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "ls -ld /var/lib/zookeeper/log"
    assert_output --partial "drwxrwxr-x."
}

@test "/etc/zookeeper/secrets should be owned by appuser:root and have 775 permissions" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/zookeeper/secrets\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/etc/zookeeper/secrets\""
    assert_output --partial "root"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "ls -ld /etc/zookeeper/secrets"
    assert_output --partial "drwxrwxr-x."
}

@test "/etc/kafka should be owned by appuser:root and have 775 permissions" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/kafka\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/etc/kafka\""
    assert_output --partial "root"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "ls -ld /etc/kafka"
    assert_output --partial "drwxrwxr-x."
}
	
@test "/var/log/kafka should be owned by appuser:root and have 770 permissions" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/var/log/kafka\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/var/log/kafka\""
    assert_output --partial "root"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "ls -ld /var/log/kafka"
    assert_output --partial "drwxrwx---."
}

@test "/var/log/confluent should be owned by appuser:root and have 770 permissions" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/var/log/confluent\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/var/log/confluent\""
    assert_output --partial "root"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "ls -ld /var/log/confluent"
    assert_output --partial "drwxrwx---."
}

@test "/var/lib/kafka should be owned by appuser:root and have 770 permissions" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/var/lib/kafka\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%G\" \"/var/lib/kafka\""
    assert_output --partial "root"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "ls -ld /var/lib/kafka"
    assert_output --partial "drwxrwx---."
}

@test "/etc/zookeeper/secrets should be a volume" {
    run bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Volumes'"
    assert_output --partial "\"/etc/zookeeper/secrets\":{}"
}

@test "/var/lib/zookeeper/log should be a volume" {
    run bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Volumes'"
    assert_output --partial "\"/var/lib/zookeeper/log\":{}"
}

@test "/var/lib/zookeeper/data should be a volume" {
    run bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Volumes'"
    assert_output --partial "\"/var/lib/zookeeper/data\":{}"
}

@test "/etc/confluent/docker should be a directory and should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker\""
    assert_output --partial "appuser"
}

@test "/etc/confluent/docker/configure should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/configure\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/configure | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/configure | cut -f1 -d\" \")"
}

@test "/etc/confluent/docker/ensure should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/ensure\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/ensure | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/ensure | cut -f1 -d\" \")"
}

@test "/etc/confluent/docker/launch should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/launch\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/launch | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/launch | cut -f1 -d\" \")"
}

@test "/etc/confluent/docker/log4j.properties.template should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/log4j.properties.template\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/log4j.properties.template | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/log4j.properties.template | cut -f1 -d\" \")"
}

@test "/etc/confluent/docker/myid.template should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/myid.template\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/myid.template | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/myid.template | cut -f1 -d\" \")"
}

@test "/etc/confluent/docker/run should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/run\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/run | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/run | cut -f1 -d\" \")"
}

@test "/etc/confluent/docker/tools-log4j.properties.template should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/tools-log4j.properties.template\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/tools-log4j.properties.template | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/tools-log4j.properties.template | cut -f1 -d\" \")"
}

@test "/etc/confluent/docker/zookeeper.properties.template should exist, be owned by appuser, and match the source file" {
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "stat -c \"%U\" \"/etc/confluent/docker/zookeeper.properties.template\""
    assert_output --partial "appuser"
    run $BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} /bin/bash -c "md5sum /etc/confluent/docker/zookeeper.properties.template | cut -f1 -d\" \""
    assert_output --partial "$(md5sum ./devel/src/main/docker/cp-zookeeper/include/etc/confluent/docker/zookeeper.properties.template | cut -f1 -d\" \")"
}

@test "whoami should be appuser" {
    run bash -c "$BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} whoami" 3>&-
    assert_output --partial "appuser"
}

@test "pwd should be /home/appuser/" {
    run bash -c "$BATS_BUILD_TOOL exec -it cp-zookeeper-test-${ARCH} pwd" 3>&-
    assert_output --partial "/home/appuser"
}

@test "cmd should be /etc/confluent/docker/run" {
    run bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Cmd | .[0]'"
    assert_output "/etc/confluent/docker/run"
}

@test "ENV COMPONENT should be 'zookeeper'" {
    run bash -c "$BATS_BUILD_TOOL inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Env'"
    assert_output --partial "COMPONENT=zookeeper"
}
