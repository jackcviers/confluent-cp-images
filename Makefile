# You can override vars like REPOSITORY in a .local.make file
-include .local.make

SHELL := /bin/bash

BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats.sh"

IMAGE_REGISTRY ?= "docker.io"
REGISTRY_PASSWORD ?= ""
REGISTRY_USER ?= ""

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
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	$(BATS_INSTALL_SCRIPT_LOCATION)

.PHONY: build-base-arm64
build-base-arm64:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	&& build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "arm64" "localhost"

.PHONY: build-base-amd64
build-base-amd64:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	&& build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "amd64" "localhost"

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

.PHONY: make-devel
make-devel: install-bats build-images devel-create-manifests test-base-manifest
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& log_info "Run Complete!"

.PHONY: test-base-manifest
test-base-manifest:
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	VERSION=${VERSION} \
	/usr/bin/time bats ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-manifest-test.bats

.PHONY: build-base-arm64-ci
build-base-arm64-ci:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	&& build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "arm64"


.PHONY: build-base-amd64-ci
build-base-amd64-ci:
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build-base.sh" \
	&& build_base "${IMAGES_BUILD_TOOL}" "${VERSION}" "./devel/src/main/docker/cp-base-new" "amd64"

.PHONY: build-base-ci
build-base-ci: build-base-arm64-ci build-base-amd64-ci

.PHONY: publish-tagged-images-ci
publish-tagged-images-ci:
	podman push docker.io/jackcviers/cp-base-new:${ARM_64_TAG} docker://docker.io/jackcviers/cp-base-new:${ARM_64_TAG} 
	podman push docker.io/jackcviers/cp-base-new:${AMD_64_TAG} docker://docker.io/jackcviers/cp-base-new:${AMD_64_TAG}

.PHONY: create-manifest-base-ci
create-manifest-base-ci:
	${IMAGES_BUILD_TOOL} manifest create --all docker.io/jackcviers/cp-base-new:${TAG} \
	docker://docker.io/jackcviers/cp-base-new:${ARM_64_TAG} \
	docker://docker.io/jackcviers/cp-base-new:${AMD_64_TAG}

.PHONY: create-manifests-ci
create-manifests-ci: create-manifest-base-ci

.PHONY: publish-image-ci
publish-image-ci: podman push docker.io/jackcviers/cp-base-new:${TAG} docker://docker.io/jackcviers/cp-base-new:${TAG}

.PHONY: build-images-ci
build-images-ci: build-base-ci
.PHONY: make-ci
make-ci: install-bats build-images-ci publish-tagged-images-ci create-manifests-ci publish-image-ci
	source "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh" \
	&& log_info "Run Complete!"

.PHONY: clean
clean:
	-${IMAGES_BUILD_TOOL} rmi localhost/jackcviers/cp-base-new:${VERSION}
	-${IMAGES_BUILD_TOOL} rmi localhost/jackcviers/cp-base-new:${AMD_64_TAG}
	-${IMAGES_BUILD_TOOL} rmi localhost/jackcviers/cp-base-new:${ARM_64_TAG}

