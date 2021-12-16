#!/bin/bash

source "$(dirname $0)/../../colors.sh"

set -e

install_bats(){
    log_info "Checking for bats installation..."

    if ! command -v "bats" &> /dev/null;
    then
	log_error "bats not found. Installing bats..."
	return_dir=$(pwd)
	mkdir .bats-install
	cd ./.bats-install
	git clone https://github.com/bats-core/bats-core.git
	cd bats-core
	sudo ./install.sh /usr/local/
	cd -
	git clone https://github.com/bats-core/bats-support.git \
	     --depth=1 \
	     --branch master \
	     --single-branch \
	     ${BATS_LIBS_INSTALL_LOCATION}/bats-support
	git clone https://github.com/ztombol/bats-assert.git \
	     --depth=1 \
	     --branch master \
	     --single-branch \
	     ${BATS_LIBS_INSTALL_LOCATION}/bats-assert
	git clone https://github.com/bats-core/bats-file.git \
	    --depth=1 \
	    --branch master \
	    --single-branch \
	    ${BATS_LIBS_INSTALL_LOCATION}/bats-file

	cd $return_dir
	rm -rf ./.bats-install
	log_success "bats installation complete."
    else
	log_success "bats already installed."
    fi
}

install_bats

exit 0
