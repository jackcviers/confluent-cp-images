# You can override vars like REPOSITORY in a .local.make file
-include .local.make

SHELL := /bin/bash

BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats.sh"

CONFLUENT_MAJOR_VERSION ?= 7
CONFLUENT_MINOR_VERSION ?= 0
CONFLUENT_PATCH_VERSION ?= 0

IMAGES_BUILD_TOOL="podman"

install-bats:
	$(BATS_INSTALL_SCRIPT_LOCATION)

build-base:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	  && source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	  && build_base "${IMAGES_BUILD_TOOL}" "${CONFLUENT_MAJOR_VERSION}.${CONFLUENT_MINOR_VERSION}.${CONFLUENT_PATCH_VERSION}" "./devel/src/main/docker/cp-base-new"

build-images: build-base test-base

make-devel: install-bats build-images
	echo "Should run install-bats first!"
