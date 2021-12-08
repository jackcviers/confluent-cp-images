#!/bin/bash

source "$(dirname $0)/../../colors.sh"

set -e

install_bats(){
    log_info "Checking for bats installation..."

    if ! command -v "bats" &> /dev/null;
    then
	log_error "bats not found. Installing bats..."
	brew install bats-core
	log_success "bats installation complete."
    else
	log_success "bats already installed."
    fi
}

install_bats

exit 0
