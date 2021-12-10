#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

@test "openssl should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} openssl version
    assert_output --partial "OpenSSL 1.1.1k  25 Mar 2021"
}

@test "wget should be installed" {
      run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} wget -V
      assert_output --partial "GNU Wget 1.21"
}

@test "nmap should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} which nmap
    assert_output --partial "/usr/bin/nmap"
}

@test "ncat should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} which ncat
    assert_output --partial "/usr/bin/ncat"
}

@test "python3 should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} python3 --version
    assert_output --partial "3.9.2"
}

@test "tar should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} which tar
    assert_output --partial "/bin/tar"
}

@test "propcs should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l procps
    assert_output --partial "ii  procps"
}

@test "kerberos should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l krb5-user
    assert_output --partial "ii  krb5-user"
}

@test "iputils should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l iputils-arping
    assert_output --partial "ii  iputils-arping"
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l iputils-clockdiff
    assert_output --partial "ii  iputils-clockdiff"
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l iputils-ping
    assert_output --partial "ii  iputils-ping"
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l iputils-tracepath
    assert_output --partial "ii  iputils-tracepath"
}

@test "hostname should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l hostname
    assert_output --partial "ii  hostname"
}

@test "java should be java 11" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} java -version
    assert_output --partial "openjdk version \"11."
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} javac -version
    assert_output --partial "javac 11."
}

@test "pip3 should be installed" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} dpkg -l python3-pip
    assert_output --partial "ii  python3-pip"
}

@test "python command should be python3" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} python --version
    assert_output --partial "Python 3."
}

@test "pip version should be 21.*" {
    run $BATS_BUILD_TOOL run -it --rm --arch=$ARCH ${BATS_IMAGE} pip -V
    assert_output --partial "21."
}
