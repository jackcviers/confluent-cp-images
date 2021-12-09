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
