# You can override vars like REPOSITORY in a .local.make file
-include .local.make

SHELL := /bin/bash

BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats.sh"

BATS_LIBS_INSTALL_LOCATION ?= /opt/homebrew/lib/

CONFLUENT_MAJOR_VERSION ?= 7
CONFLUENT_MINOR_VERSION ?= 0
CONFLUENT_PATCH_VERSION ?= 0

VERSION=${CONFLUENT_MAJOR_VERSION}.${CONFLUENT_MINOR_VERSION}.${CONFLUENT_PATCH_VERSION}

IMAGES_BUILD_TOOL ?= podman

.ONESHELL:
install-bats:
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} $(BATS_INSTALL_SCRIPT_LOCATION)

build-base-arm64:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	  && source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	  && build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "arm64"

build-base-amd64:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	  && source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	  && build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "amd64"

build-base: build-base-arm64 build-base-amd64

test-base-arm64:
	ARCH=arm64
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.arm64 \
	/usr/bin/time bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats

test-base-amd64:
	ARCH=amd64
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.amd64 \
	/usr/bin/time bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats

test-base: test-base-arm64 test-base-amd64

build-images: build-base test-base

make-devel: install-bats build-images
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" && log_info "Run Complete!"
