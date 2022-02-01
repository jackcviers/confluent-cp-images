# You can override vars like REPOSITORY in a .local.make file
-include .local.make

SHELL := /bin/bash

SOURCE_COMMAND = source
TIME_COMMAND = /usr/bin/time
BATS_COMMAND = bats
SLEEP_COMMAND = sleep

BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats.sh"
COLORS_SOURCE = ./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/colors.sh
BUILD_SCRIPT_SOURCE = ./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/build.sh
BUILD_COMMAND = build

LOCALHOST_DOCKER_DOMAIN = localhost
IMAGE_REGISTRY ?= "docker.io"
REGISTRY_PASSWORD ?= ""
REGISTRY_USER ?= ""

DOCKER_REMOVE_IMAGE_COMMAND = rmi
DOCKER_MANIFEST_COMMAND = manifest
DOCKER_CREATE_COMMAND_PART = create
DOCKER_RM_COMMAND_PART = rm
DOCKER_ALL_COMMAND_PART = --all
DOCKER_PUSH_COMMAND = push

BATS_LIBS_INSTALL_LOCATION ?= "/opt/homebrew/lib"

CONFLUENT_MAJOR_VERSION ?= 7
CONFLUENT_MINOR_VERSION ?= 0
CONFLUENT_PATCH_VERSION ?= 0

VERSION=${CONFLUENT_MAJOR_VERSION}.${CONFLUENT_MINOR_VERSION}.${CONFLUENT_PATCH_VERSION}

IMAGES_BUILD_TOOL ?= podman

ARM_DOCKER_ARCH = arm64
AMD_DOCKER_ARCH = amd64

AMD_64_TAG = ${VERSION}.${AMD_DOCKER_ARCH}
ARM_64_TAG = ${VERSION}.${ARM_DOCKER_ARCH}

CP_BASE_NEW_DOCKER_CONTEXT_DIR = devel/src/main/docker/cp-base-new
CP_BASE_NEW_COMPONENT = cp-base-new
CP_BASE_NEW_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats
CP_BASE_NEW_MANIFEST_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/manifest-test.bats
DOCKER_HUB_CP_BASE_NEW_ARM_64_IMAGE = docker.io/jackcviers/${CP_BASE_NEW_COMPONENT}:${ARM_64_TAG}
DOCKER_HUB_CP_BASE_NEW_AMD_64_IMAGE = docker.io/jackcviers/${CP_BASE_NEW_COMPONENT}:${AMD_64_TAG}
DOCKER_HUB_CP_BASE_NEW_IMAGE = docker.io/jackcviers/${CP_BASE_NEW_COMPONENT}:${VERSION}
DOCKER_HUB_CP_BASE_NEW_LATEST = docker.io/jackcviers/${CP_BASE_NEW_COMPONENT}:latest
LOCAL_CP_BASE_NEW_ARM_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_BASE_NEW_COMPONENT}:${ARM_64_TAG}
LOCAL_CP_BASE_NEW_AMD_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_BASE_NEW_COMPONENT}:${AMD_64_TAG}
LOCAL_CP_BASE_NEW_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_BASE_NEW_COMPONENT}:${VERSION}

CP_KERBEROS_DOCKER_CONTEXT_DIR = devel/src/main/docker/cp-kerberos
CP_KERBEROS_COMPONENT = cp-kerberos
CP_KERBEROS_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kerberos/cp-kerberos-test.bats
CP_KERBEROS_MANIFEST_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/manifest-test.bats
DOCKER_HUB_CP_KERBEROS_ARM_64_IMAGE = docker.io/jackcviers/${CP_KERBEROS_COMPONENT}:${ARM_64_TAG}
DOCKER_HUB_CP_KERBEROS_AMD_64_IMAGE = docker.io/jackcviers/${CP_KERBEROS_COMPONENT}:${AMD_64_TAG}
DOCKER_HUB_CP_KERBEROS_IMAGE = docker.io/jackcviers/${CP_KERBEROS_COMPONENT}:${VERSION}
DOCKER_HUB_CP_KERBEROS_LATEST = docker.io/jackcviers/${CP_KERBEROS_COMPONENT}:latest
LOCAL_CP_KERBEROS_ARM_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_KERBEROS_COMPONENT}:${ARM_64_TAG}
LOCAL_CP_KERBEROS_AMD_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_KERBEROS_COMPONENT}:${AMD_64_TAG}
LOCAL_CP_KERBEROS_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_KERBEROS_COMPONENT}:${VERSION}

CP_JMXTERM_DOCKER_CONTEXT_DIR = devel/src/main/docker/cp-jmxterm
CP_JMXTERM_COMPONENT = cp-jmxterm
CP_JMXTERM_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-jmxterm/cp-jmxterm-test.bats
CP_JMXTERM_MANIFEST_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/manifest-test.bats
DOCKER_HUB_CP_JMXTERM_ARM_64_IMAGE = docker.io/jackcviers/${CP_JMXTERM_COMPONENT}:${ARM_64_TAG}
DOCKER_HUB_CP_JMXTERM_AMD_64_IMAGE = docker.io/jackcviers/${CP_JMXTERM_COMPONENT}:${AMD_64_TAG}
DOCKER_HUB_CP_JMXTERM_IMAGE = docker.io/jackcviers/${CP_JMXTERM_COMPONENT}:${VERSION}
DOCKER_HUB_CP_JMXTERM_LATEST = docker.io/jackcviers/${CP_JMXTERM_COMPONENT}:latest
LOCAL_CP_JMXTERM_ARM_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_JMXTERM_COMPONENT}:${ARM_64_TAG}
LOCAL_CP_JMXTERM_AMD_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_JMXTERM_COMPONENT}:${AMD_64_TAG}
LOCAL_CP_JMXTERM_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_JMXTERM_COMPONENT}:${VERSION}


MANIFEST_LOCAL_PROTOCOL = containers-storage
DOCKER_PROTOCOL = docker://

.ONESHELL:

.PHONY: install-bats
install-bats:
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	$(BATS_INSTALL_SCRIPT_LOCATION)

.PHONY: build-base-arm64
build-base-arm64:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_BASE_NEW_DOCKER_CONTEXT_DIR}" "${ARM_DOCKER_ARCH}" "${CP_BASE_NEW_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-base-amd64
build-base-amd64:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_BASE_NEW_DOCKER_CONTEXT_DIR}" "${AMD_DOCKER_ARCH}" "${CP_BASE_NEW_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-base
build-base: build-base-arm64 build-base-amd64

.PHONY: build-cp-kerberos-arm64
build-cp-kerberos-arm64:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KERBEROS_DOCKER_CONTEXT_DIR}" "${ARM_DOCKER_ARCH}" "${CP_KERBEROS_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-kerberos-amd64
build-cp-kerberos-amd64:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KERBEROS_DOCKER_CONTEXT_DIR}" "${AMD_DOCKER_ARCH}" "${CP_KERBEROS_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-kerberos
build-cp-kerberos: build-cp-kerberos-arm64 build-cp-kerberos-amd64

.PHONY: build-cp-jmxterm-arm64
build-cp-jmxterm-arm64:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_JMXTERM_DOCKER_CONTEXT_DIR}" "${ARM_DOCKER_ARCH}" "${CP_JMXTERM_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-jmxterm-amd64
build-cp-jmxterm-amd64:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_JMXTERM_DOCKER_CONTEXT_DIR}" "${AMD_DOCKER_ARCH}" "${CP_JMXTERM_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-jmxterm
build-cp-jmxterm: build-cp-jmxterm-arm64 build-cp-jmxterm-amd64

.PHONY: test-base-arm64
test-base-arm64:
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_BASE_NEW_ARM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_BASE_NEW_TEST_LOCATION}

.PHONY: test-base-amd64
test-base-amd64:
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_BASE_NEW_AMD_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_BASE_NEW_TEST_LOCATION}

.PHONY: devel-create-manifest-base
devel-create-manifest-base:
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_BASE_NEW_IMAGE}
	${SLEEP_COMMAND} 1
	${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_CREATE_COMMAND_PART} ${DOCKER_ALL_COMMAND_PART} ${LOCAL_CP_BASE_NEW_IMAGE} \
	${MANIFEST_LOCAL_PROTOCOL}:${LOCAL_CP_BASE_NEW_ARM_IMAGE} \
	${MANIFEST_LOCAL_PROTOCOL}:${LOCAL_CP_BASE_NEW_AMD_IMAGE}

.PHONY: test-base
test-base: test-base-arm64 test-base-amd64

.PHONY: test-cp-kerberos-arm64
test-cp-kerberos-arm64:
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KERBEROS_ARM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KERBEROS_TEST_LOCATION}

.PHONY: test-cp-kerberos-amd64
test-cp-kerberos-amd64:
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KERBEROS_AMD_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KERBEROS_TEST_LOCATION}

.PHONY: devel-create-manifest-cp-kerberos
devel-create-manifest-cp-kerberos:
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_KERBEROS_IMAGE}
	${SLEEP_COMMAND} 1
	${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_CREATE_COMMAND_PART} ${DOCKER_ALL_COMMAND_PART} ${LOCAL_CP_KERBEROS_IMAGE} \
	${MANIFEST_LOCAL_PROTOCOL}:${LOCAL_CP_KERBEROS_ARM_IMAGE} \
	${MANIFEST_LOCAL_PROTOCOL}:${LOCAL_CP_KERBEROS_AMD_IMAGE}

.PHONY: test-cp-kerberos
test-cp-kerberos: test-cp-kerberos-arm64 test-cp-kerberos-amd64

.PHONY: test-cp-jmxterm-arm64
test-cp-jmxterm-arm64:
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_JMXTERM_ARM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_JMXTERM_TEST_LOCATION}

.PHONY: test-cp-jmxterm-amd64
test-cp-jmxterm-amd64:
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_JMXTERM_AMD_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_JMXTERM_TEST_LOCATION}

.PHONY: devel-create-manifest-cp-jmxterm
devel-create-manifest-cp-jmxterm:
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_JMXTERM_IMAGE}
	${SLEEP_COMMAND} 1
	${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_CREATE_COMMAND_PART} ${DOCKER_ALL_COMMAND_PART} ${LOCAL_CP_JMXTERM_IMAGE} \
	${MANIFEST_LOCAL_PROTOCOL}:${LOCAL_CP_JMXTERM_ARM_IMAGE} \
	${MANIFEST_LOCAL_PROTOCOL}:${LOCAL_CP_JMXTERM_AMD_IMAGE}

.PHONY: test-cp-jmxterm
test-cp-jmxterm: test-cp-jmxterm-arm64 test-cp-jmxterm-amd64

.PHONY: build-images
build-images: build-base test-base devel-create-manifest-base test-base-manifest build-cp-kerberos test-cp-kerberos devel-create-manifest-cp-kerberos test-cp-kerberos-manifest build-cp-jmxterm test-cp-jmxterm devel-create-manifest-cp-jmxterm test-cp-jmxterm-manifest

.PHONY: test-base-manifest
test-base-manifest:
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	IMAGE=${LOCAL_CP_BASE_NEW_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_BASE_NEW_MANIFEST_TEST_LOCATION}

.PHONY: test-cp-kerberos-manifest
test-cp-kerberos-manifest:
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	IMAGE=${LOCAL_CP_KERBEROS_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KERBEROS_MANIFEST_TEST_LOCATION}

.PHONY: test-cp-jmxterm-manifest
test-cp-jmxterm-manifest:
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_JMXTERM_MANIFEST_TEST_LOCATION}

.PHONY: make-devel
make-devel: install-bats build-images
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& log_info "Run Complete!"


.PHONY: build-base-arm64-ci
build-base-arm64-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_BASE_NEW_DOCKER_CONTEXT_DIR}" "${ARM_DOCKER_ARCH}" "${CP_BASE_NEW_COMPONENT}"

.PHONY: build-base-amd64-ci
build-base-amd64-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_BASE_NEW_DOCKER_CONTEXT_DIR}" "${AMD_DOCKER_ARCH}" "${CP_BASE_NEW_COMPONENT}"

.PHONY: build-base-ci
build-base-ci: build-base-arm64-ci build-base-amd64-ci

.PHONY: build-cp-kerberos-arm64-ci
build-cp-kerberos-arm64-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KERBEROS_DOCKER_CONTEXT_DIR}" "${ARM_DOCKER_ARCH}" "${CP_KERBEROS_COMPONENT}"


.PHONY: build-cp-kerberos-amd64-ci
build-cp-kerberos-amd64-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KERBEROS_DOCKER_CONTEXT_DIR}" "${AMD_DOCKER_ARCH}" "${CP_KERBEROS_COMPONENT}"

.PHONY: build-cp-kerberos-ci
build-cp-kerberos-ci: build-cp-kerberos-arm64-ci build-cp-kerberos-amd64-ci

.PHONY: build-cp-jmxterm-arm64-ci
build-cp-jmxterm-arm64-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_JMXTERM_DOCKER_CONTEXT_DIR}" "${ARM_DOCKER_ARCH}" "${CP_JMXTERM_COMPONENT}"


.PHONY: build-cp-jmxterm-amd64-ci
build-cp-jmxterm-amd64-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_JMXTERM_DOCKER_CONTEXT_DIR}" "${AMD_DOCKER_ARCH}" "${CP_JMXTERM_COMPONENT}"

.PHONY: build-cp-jmxterm-ci
build-cp-jmxterm-ci: build-cp-jmxterm-arm64-ci build-cp-jmxterm-amd64-ci

.PHONY: publish-tagged-images-ci
publish-tagged-images-ci:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_BASE_NEW_ARM_64_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_BASE_NEW_ARM_64_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_BASE_NEW_AMD_64_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_BASE_NEW_AMD_64_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_KERBEROS_ARM_64_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_KERBEROS_ARM_64_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_KERBEROS_AMD_64_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_KERBEROS_AMD_64_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_JMXTERM_ARM_64_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_JMXTERM_ARM_64_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_JMXTERM_AMD_64_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_JMXTERM_AMD_64_IMAGE}

.PHONY: create-manifest-base-ci
create-manifest-base-ci:
	-${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_RM_COMMAND_PART} ${DOCKER_HUB_CP_BASE_NEW_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_CREATE_COMMAND_PART} ${DOCKER_ALL_COMMAND_PART} ${DOCKER_HUB_CP_BASE_NEW_IMAGE} \
	${DOCKER_PROTOCOL}${DOCKER_HUB_CP_BASE_NEW_ARM_64_IMAGE} \
	${DOCKER_PROTOCOL}${DOCKER_HUB_CP_BASE_NEW_AMD_64_IMAGE}

.PHONY: create-manifest-cp-kerberos-ci
create-manifest-cp-kerberos-ci:
	-${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_RM_COMMAND_PART} ${DOCKER_HUB_CP_KERBEROS_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_CREATE_COMMAND_PART} ${DOCKER_ALL_COMMAND_PART} ${DOCKER_HUB_CP_KERBEROS_IMAGE} \
	${DOCKER_PROTOCOL}${DOCKER_HUB_CP_KERBEROS_ARM_64_IMAGE} \
	${DOCKER_PROTOCOL}${DOCKER_HUB_CP_KERBEROS_AMD_64_IMAGE}

.PHONY: create-manifest-cp-jmxterm-ci
create-manifest-cp-jmxterm-ci:
	-${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_RM_COMMAND_PART} ${DOCKER_HUB_CP_JMXTERM_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_MANIFEST_COMMAND} ${DOCKER_CREATE_COMMAND_PART} ${DOCKER_ALL_COMMAND_PART} ${DOCKER_HUB_CP_JMXTERM_IMAGE} \
	${DOCKER_PROTOCOL}${DOCKER_HUB_CP_JMXTERM_ARM_64_IMAGE} \
	${DOCKER_PROTOCOL}${DOCKER_HUB_CP_JMXTERM_AMD_64_IMAGE}

.PHONY: create-manifests-ci
create-manifests-ci: create-manifest-base-ci create-manifest-cp-kerberos-ci create-manifest-cp-jmxterm-ci

.PHONY: publish-images-ci
publish-images-ci:
	${IMAGES_BUILD_TOOL} tag ${DOCKER_HUB_CP_BASE_NEW_IMAGE} ${DOCKER_HUB_CP_BASE_NEW_LATEST}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_BASE_NEW_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_BASE_NEW_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_BASE_NEW_LATEST} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_BASE_NEW_LATEST}
	${IMAGES_BUILD_TOOL} tag ${DOCKER_HUB_CP_KERBEROS_IMAGE} ${DOCKER_HUB_CP_KERBEROS_LATEST}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_KERBEROS_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_KERBEROS_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_KERBEROS_LATEST} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_KERBEROS_LATEST}
	${IMAGES_BUILD_TOOL} tag ${DOCKER_HUB_CP_JMXTERM_IMAGE} ${DOCKER_HUB_CP_JMXTERM_LATEST}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_JMXTERM_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_JMXTERM_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_JMXTERM_LATEST} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_JMXTERM_LATEST}

.PHONY: build-images-ci
build-images-ci: build-base-ci build-cp-kerberos-ci build-cp-jmxterm-ci

.PHONY: make-ci
make-ci: install-bats build-images-ci publish-tagged-images-ci create-manifests-ci publish-images-ci
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& log_info "Run Complete!"

.PHONY: clean
clean:
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_BASE_NEW_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_BASE_NEW_AMD_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_BASE_NEW_ARM_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_KERBEROS_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_KERBEROS_AMD_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_KERBEROS_ARM_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_JMXTERM_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_JMXTERM_AMD_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_JMXTERM_ARM_IMAGE}

