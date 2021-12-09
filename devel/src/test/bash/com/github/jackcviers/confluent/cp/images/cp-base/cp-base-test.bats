#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

@test "openssl should be installed" {
    run podman run -it --rm --arch=$ARCH ${BATS_IMAGE} openssl version
    assert_output --partial "OpenSSL 1.1.1k  25 Mar 2021"
}
