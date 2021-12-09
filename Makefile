# You can override vars like REPOSITORY in a .local.make file
-include .local.make

SHELL := /bin/bash

BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats.sh"

CONFLUENT_MAJOR_VERSION ?= 7
CONFLUENT_MINOR_VERSION ?= 0
CONFLUENT_PATCH_VERSION ?= 0

VERSION=${CONFLUENT_MAJOR_VERSION}.${CONFLUENT_MINOR_VERSION}.${CONFLUENT_PATCH_VERSION}

IMAGES_BUILD_TOOL=podman

install-bats:
	$(BATS_INSTALL_SCRIPT_LOCATION)

build-base:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	  && source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	  && build_base "${IMAGES_BUILD_TOOL}" "${VERSION}"  "./devel/src/main/docker/cp-base-new"

test-base:
	ARCH=arm64
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.arm64 \
	bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats
	ARCH=amd64
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.amd64 \
	bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats

build-images: build-base test-base

make-devel: install-bats build-images
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" && log_info "Run Complete!"
