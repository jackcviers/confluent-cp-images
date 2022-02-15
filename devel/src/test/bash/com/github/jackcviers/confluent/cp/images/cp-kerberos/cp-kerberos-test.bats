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
    $BATS_BUILD_TOOL run -d --platform=$ARCH --name cp-kerberos-test-${ARCH} ${BATS_IMAGE} tail -f /dev/null
}

teardown_file(){
    container=cp-kerberos-test-${ARCH}
    $BATS_BUILD_TOOL stop -t 2 ${container}
    $BATS_BUILD_TOOL container rm ${container}
}

@test "the KRB5_CONFIG env variable should be /etc/krb5.conf" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Env'"
    assert_output --partial "KRB5_CONFIG=/etc/krb5.conf"
}

@test "the KRB5_KDC_PROFILE env variable should be /etc/krb5kdc/kdc.conf" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} inspect ${BATS_IMAGE} | jq -cr '.[0].Config.Env'"
    assert_output --partial "KRB5_KDC_PROFILE=/etc/krb5kdc/kdc.conf"
}

@test "the krb5-kdc krb5-admin-server krb5-config packages should be installed" {
    run bash -c "unbuffer $BATS_BUILD_TOOL exec -it cp-kerberos-test-${ARCH} apt list krb5-kdc krb5-admin-server krb5-config --installed"
    assert_output --partial "krb5-kdc"
    assert_output --partial "krb5-admin-server"
    assert_output --partial "krb5-config"
}

@test "kerberos service should be in place" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} service --status-all"
    assert_output --partial "krb5-admin-server"
    assert_output --partial "krb5-kdc"
}

@test "/usr/local/var/krb5kdc/principal should exist" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} ls -al /var/lib/krb5kdc/principal"
    assert_output --partial "-rw------- 1 root root"
}

@test "etc/krb5kdc/kadm5.acl should be */admin@TEST.CONFLUENT.IO    *" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} cat /etc/krb5kdc/kadm5.acl"
    assert_output --partial "*/admin@TEST.CONFLUENT.IO    *"
}

@test "/write-krb5-conf.sh should contain the reaml information" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} cat /write-krb5-conf.sh"
    assert_output --partial "#!/bin/bash"
    assert_output --partial "set -e"
    assert_output --partial "cat > \${KRB5_CONFIG} <<EOF"
    assert_output --partial "[libdefaults]"
    assert_output --partial "    default_realm = TEST.CONFLUENT.IO"
    assert_output --partial "[realms]"
    assert_output --partial "    TEST.CONFLUENT.IO = {"
    assert_output --partial "        kdc = \$(hostname -f)"
    assert_output --partial "        admin_server = \$(hostname -f)"
    assert_output --partial "    }"
    assert_output --partial "EOF"
}

@test "/etc/krb5.conf should exist" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} cat /etc/krb5.conf"
    assert_output --partial "[libdefaults]"
    assert_output --partial "    default_realm = TEST.CONFLUENT.IO"
    assert_output --partial "[realms]"
    assert_output --partial "    TEST.CONFLUENT.IO = {"
    assert_output --partial "        kdc ="
    assert_output --partial "        admin_server ="
    assert_output --partial "    }"
}

@test "/etc/krb5kdc/kdc.conf should contain the realm information" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} cat /etc/krb5kdc/kdc.conf
    assert_output --partial "TEST.CONFLUENT.IO"
}

@test "adding a principal should work" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} kadmin.local -q "addprinc -randkey zookeeper/test.confluent.io@TEST.CONFLUENT.IO"
    assert_success
}

@test "adding a keytab should work" {
    run unbuffer ${BATS_BUILD_TOOL} exec -it cp-kerberos-test-${ARCH} kadmin.local -q "ktadd -norandkey -k /tmp/keytab/zookeeper-config.keytab zookeeper/test.confluent.io@TEST.CONFLUENT.IO"
    assert_success
}

@test "/var/run/krb5 should be a volume" {
    run bash -c "unbuffer ${BATS_BUILD_TOOL} inspect ${BATS_IMAGE} | jq -c '.[0].Config.Volumes'"
    assert_output --partial "/var/run/krb5"
}
