#!/usr/bin/env bats

@test "openssl should be installed" {
    result="$(BUILD_TOOL) run -it ${IMAGE} openssl version"
    [ "$result" -eq "1"]
}
