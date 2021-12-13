#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'


setup_file(){
    run $BATS_BUILD_TOOL run -d -t --arch=$ARCH --name cp-base-test-${ARCH} ${BATS_IMAGE} tail -f /dev/null
}

teardown_file(){
    run $BATS_BUILD_TOOL kill cp-base-test-${ARCH}
    run $BATS_BUILD_TOOL container rm cp-base-test-${ARCH}
}

@test "openssl should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} openssl version
    assert_output --partial "OpenSSL 1.1.1k  25 Mar 2021"
}

@test "wget should be installed" {
      run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} wget -V
      assert_output --partial "GNU Wget 1.21"
}

@test "nmap should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} which nmap
    assert_output --partial "/usr/bin/nmap"
}

@test "ncat should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} which ncat
    assert_output --partial "/usr/bin/ncat"
}

@test "python3 should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} python3 --version
    assert_output --partial "3.9.2"
}

@test "tar should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} which tar
    assert_output --partial "/bin/tar"
}

@test "propcs should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l procps
    assert_output --partial "ii  procps"
}

@test "kerberos should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l krb5-user
    assert_output --partial "ii  krb5-user"
}

@test "iputils should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l iputils-arping
    assert_output --partial "ii  iputils-arping"
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l iputils-clockdiff
    assert_output --partial "ii  iputils-clockdiff"
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l iputils-ping
    assert_output --partial "ii  iputils-ping"
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l iputils-tracepath
    assert_output --partial "ii  iputils-tracepath"
}

@test "hostname should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l hostname
    assert_output --partial "ii  hostname"
}

@test "java should be java 11" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} java -version
    assert_output --partial "openjdk version \"11."
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} javac -version
    assert_output --partial "javac 11."
}

@test "pip3 should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l python3-pip
    assert_output --partial "ii  python3-pip"
}

@test "python command should be python3" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} python --version
    assert_output --partial "Python 3."
}

@test "pip version should be 21.*" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} pip -V
    assert_output --partial "21."
}

@test "confluent-docker-utils should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} pip show confluent-docker-utils
    assert_output --partial "Version: 0.0.49"
}

@test "git should not be installed after installing confluent-docker-utils" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l git
    refute_output --partial "ii  git"
}

@test "tzdata should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l tzdata
    assert_output --partial "ii  tzdata"
}

@test "libgcc-s1 should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l libgcc-s1
    assert_output --partial "ii  libgcc-s1"
}

@test "gcc-10-base should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l gcc-10-base
    assert_output --partial "ii  gcc-10-base"
}

@test "libstdc++6 should be installed" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} dpkg -l libstdc++6
    assert_output --partial "ii  libstdc++6"
}

@test "/etc/confluent/docker should be a directory" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -d /etc/confluent/docker
    assert_success 
}

@test "/usr/logs should be a directory" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -d /usr/logs
    assert_success 
}

@test "the user: appuser should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} id "appuser"
    assert_success
}

@test "the /etc/confluent/docker directory should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /etc/confluent/docker
    assert_output --partial "appuser"
}

@test "/usr/share/java/cp-base-new/argparse4j-0.7.0.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/argparse4j-0.7.0.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/argparse4j-0.7.0.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/argparse4j-0.7.0.jar
    assert_output --partial "appuser"
}

@test "/usr/share/java/cp-base-new/audience-annotations-0.5.0.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/audience-annotations-0.5.0.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/audience-annotations-0.5.0.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/audience-annotations-0.5.0.jar
    assert_output --partial "appuser"
}

@test "/usr/share/java/cp-base-new/common-utils-7.0.0.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/common-utils-7.0.0.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/common-utils-7.0.0.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/common-utils-7.0.0.jar
    assert_output --partial "appuser"
}

@test "/usr/share/java/cp-base-new/commons-cli-1.4.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/commons-cli-1.4.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/commons-cli-1.4.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/commons-cli-1.4.jar
    assert_output --partial "appuser"
}

@test "/usr/share/java/cp-base-new/confluent-log4j-1.2.17-cp2.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/confluent-log4j-1.2.17-cp2.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/confluent-log4j-1.2.17-cp2.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/confluent-log4j-1.2.17-cp2.jar
    assert_output --partial "appuser"
}

@test "/usr/share/java/cp-base-new/disk-usage-agent-7.0.0.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/disk-usage-agent-7.0.0.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/disk-usage-agent-7.0.0.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/disk-usage-agent-7.0.0.jar
    assert_output --partial "appuser"
}

@test "/usr/share/java/cp-base-new/gson-2.8.6.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/gson-2.8.6.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/gson-2.8.6.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/gson-2.8.6.jar
    assert_output --partial "appuser"
}
@test "/usr/share/java/cp-base-new/jackson-annotations-2.12.3.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/jackson-annotations-2.12.3.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/jackson-annotations-2.12.3.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/jackson-annotations-2.12.3.jar
    assert_output --partial "appuser"
}
@test "/usr/share/java/cp-base-new/jackson-core-2.12.3.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/jackson-core-2.12.3.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/jackson-core-2.12.3.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/jackson-core-2.12.3.jar
    assert_output --partial "appuser"
}
@test "/usr/share/java/cp-base-new/jackson-databind-2.12.3.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/jackson-databind-2.12.3.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/jackson-databind-2.12.3.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/jackson-databind-2.12.3.jar
    assert_output --partial "appuser"
}
@test "/usr/share/java/cp-base-new/jackson-dataformat-csv-2.12.3.jar should exist" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} test -f /usr/share/java/cp-base-new/jackson-dataformat-csv-2.12.3.jar
    assert_success
}

@test "/usr/share/java/cp-base-new/jackson-dataformat-csv-2.12.3.jar should be owned by appuser" {
    run $BATS_BUILD_TOOL exec -it cp-base-test-${ARCH} stat -c '%U' /usr/share/java/cp-base-new/jackson-dataformat-csv-2.12.3.jar
    assert_output --partial "appuser"
}
