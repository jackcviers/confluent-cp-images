#!/bin/bash

source "$(dirname $0)/../../colors.sh"

set -e

install_bats(){
    log_info "Checking for bats installation..."

    if ! command -v "bats" &> /dev/null;
    then
	log_error "bats not found. Installing bats..."
	brew tap kaos/shell
	brew install bats-assert
	brew install bats-file
	log_success "bats installation complete."
    else
	log_success "bats already installed."
    fi	
}

install_bats

exit 0
