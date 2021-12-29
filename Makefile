# You can override vars like REPOSITORY in a .local.make file
-include .local.make

SHELL ?= /bin/bash

BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats.sh"

BATS_LIBS_INSTALL_LOCATION ?= "/opt/homebrew/lib"

CONFLUENT_MAJOR_VERSION ?= 7
CONFLUENT_MINOR_VERSION ?= 0
CONFLUENT_PATCH_VERSION ?= 0

VERSION=${CONFLUENT_MAJOR_VERSION}.${CONFLUENT_MINOR_VERSION}.${CONFLUENT_PATCH_VERSION}

IMAGES_BUILD_TOOL ?= podman

TAG=${VERSION}
AMD_64_TAG=${TAG}.amd64
ARM_64_TAG=${TAG}.arm64

.ONESHELL:

.PHONY: install-bats
install-bats:
	$(BATS_INSTALL_SCRIPT_LOCATION)

.PHONY: build-base-arm64
build-base-arm64:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	&& build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "arm64"

.PHONY: build-base-amd64
build-base-amd64:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	&& build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "amd64"

.PHONY: build-base
build-base: build-base-arm64 build-base-amd64


.PHONY: test-base-arm64
test-base-arm64:
	ARCH=arm64 \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.arm64 \
	/usr/bin/time bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats

.PHONY: test-base-amd64
test-base-amd64:
	ARCH=amd64 \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=localhost/jackcviers/cp-base-new:${VERSION}.amd64 \
	/usr/bin/time bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats

.PHONY: devel-create-manifest-base
devel-create-manifest-base:
	${IMAGES_BUILD_TOOL} manifest create --all localhost/jackcviers/cp-base-new:${TAG} \
	containers-storage:localhost/jackcviers/cp-base-new:${ARM_64_TAG} \
	containers-storage:localhost/jackcviers/cp-base-new:${AMD_64_TAG} 

.PHONY: devel-create-manifests
devel-create-manifests: devel-create-manifest-base

.PHONY: test-base
test-base: test-base-arm64 test-base-amd64

.PHONY: build-images
build-images: build-base test-base

.PHONY: test-base-manifest
test-base-manifest:
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	VERSION=${VERSION} \
	/usr/bin/time bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-manifest-test.bats

.PHONY: make-devel
make-devel: install-bats build-images devel-create-manifests test-base-manifest
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& log_info "Run Complete!"

.PHONY: clean
clean:
	-${IMAGES_BUILD_TOOL} rmi localhost/jackcviers/cp-base-new:${VERSION}
	-${IMAGES_BUILD_TOOL} rmi localhost/jackcviers/cp-base-new:${AMD_64_TAG}
	-${IMAGES_BUILD_TOOL} rmi localhost/jackcviers/cp-base-new:${ARM_64_TAG}

