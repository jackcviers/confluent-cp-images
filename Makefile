# Copyright 2021 Jack Viers

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# You can override vars like REPOSITORY in a .local.make file
-include .local.make

SHELL := /bin/bash

BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats.sh"

BATS_LIBS_INSTALL_LOCATION ?= /opt/homebrew/lib/

CONFLUENT_MAJOR_VERSION ?= 7
CONFLUENT_MINOR_VERSION ?= 0
CONFLUENT_PATCH_VERSION ?= 0

DOCKER_REGISTRY_LOCAL_PORT ?= 7413

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
	time ARCH="arm64" BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.arm64 BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats

test-base-amd64:
	time ARCH="amd64" BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.amd64 BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats

test-base: test-base-arm64 test-base-amd64

build-images: build-base test-base

make-devel: install-bats build-images
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" && log_info "Run Complete!"
