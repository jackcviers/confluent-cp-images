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

LOCALHOST_DOCKER_DOMAIN = localhost:5000
IMAGE_REGISTRY ?= "docker.io"
REGISTRY_PASSWORD ?= ""
REGISTRY_USER ?= ""

DOCKER_REMOVE_IMAGE_COMMAND = rmi
DOCKER_MANIFEST_COMMAND = manifest
DOCKER_CREATE_COMMAND_PART = create
DOCKER_RM_COMMAND_PART = rm
DOCKER_ALL_COMMAND_PART = --all
DOCKER_PUSH_COMMAND = push --all-platforms

BATS_LIBS_INSTALL_LOCATION ?= "/opt/homebrew/lib"

CONFLUENT_MAJOR_VERSION ?= 7
CONFLUENT_MINOR_VERSION ?= 0
CONFLUENT_PATCH_VERSION ?= 0

VERSION=${CONFLUENT_MAJOR_VERSION}.${CONFLUENT_MINOR_VERSION}.${CONFLUENT_PATCH_VERSION}

IMAGES_BUILD_TOOL ?= nerdctl

ARM_DOCKER_ARCH = arm64
AMD_DOCKER_ARCH = amd64

AMD_64_TAG = ${VERSION}.${AMD_DOCKER_ARCH}
ARM_64_TAG = ${VERSION}.${ARM_DOCKER_ARCH}

CP_BASE_NEW_DOCKER_CONTEXT_DIR = ./devel/src/main/docker/cp-base-new
CP_BASE_NEW_COMPONENT = cp-base-new
CP_BASE_NEW_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats
CP_BASE_NEW_MANIFEST_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/manifest-test.bats
DOCKER_HUB_CP_BASE_NEW_IMAGE = docker.io/jackcviers/${CP_BASE_NEW_COMPONENT}:${VERSION}
DOCKER_HUB_CP_BASE_NEW_LATEST = docker.io/jackcviers/${CP_BASE_NEW_COMPONENT}:latest
LOCAL_CP_BASE_NEW_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_BASE_NEW_COMPONENT}:${VERSION}


CP_KERBEROS_COMPONENT = cp-kerberos
CP_KERBEROS_DOCKER_CONTEXT_DIR = ./devel/src/main/docker/${CP_KERBEROS_COMPONENT}
CP_KERBEROS_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kerberos/cp-kerberos-test.bats
DOCKER_HUB_CP_KERBEROS_IMAGE = docker.io/jackcviers/${CP_KERBEROS_COMPONENT}:${VERSION}
DOCKER_HUB_CP_KERBEROS_LATEST = docker.io/jackcviers/${CP_KERBEROS_COMPONENT}:latest
LOCAL_CP_KERBEROS_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_KERBEROS_COMPONENT}:${VERSION}

CP_JMXTERM_COMPONENT = cp-jmxterm
CP_JMXTERM_DOCKER_CONTEXT_DIR = ./devel/src/main/docker/${CP_JMXTERM_COMPONENT}
CP_JMXTERM_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_JMXTERM_COMPONENT}/${CP_JMXTERM_COMPONENT}-test.bats
DOCKER_HUB_CP_JMXTERM_IMAGE = docker.io/jackcviers/${CP_JMXTERM_COMPONENT}:${VERSION}
DOCKER_HUB_CP_JMXTERM_LATEST = docker.io/jackcviers/${CP_JMXTERM_COMPONENT}:latest
LOCAL_CP_JMXTERM_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/jackcviers/${CP_JMXTERM_COMPONENT}:${VERSION}


DOCKER_PROTOCOL = docker://

.ONESHELL:

.PHONY: install-bats
install-bats:
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	$(BATS_INSTALL_SCRIPT_LOCATION)


.PHONY: build-base
build-base:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_BASE_NEW_DOCKER_CONTEXT_DIR}" "${CP_BASE_NEW_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-kerberos
build-cp-kerberos:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KERBEROS_DOCKER_CONTEXT_DIR}" "${CP_KERBEROS_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-jmxterm
build-cp-jmxterm:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_JMXTERM_DOCKER_CONTEXT_DIR}" "${CP_JMXTERM_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: test-base-arm64
test-base-arm64:
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_BASE_NEW_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_BASE_NEW_TEST_LOCATION}

.PHONY: test-base-amd64
test-base-amd64:
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_BASE_NEW_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_BASE_NEW_TEST_LOCATION}

.PHONY: test-base
test-base: test-base-arm64 test-base-amd64

.PHONY: test-cp-kerberos-arm64
test-cp-kerberos-arm64:
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KERBEROS_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KERBEROS_TEST_LOCATION}

.PHONY: test-cp-kerberos-amd64
test-cp-kerberos-amd64:
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KERBEROS_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KERBEROS_TEST_LOCATION}

.PHONY: test-cp-kerberos
test-cp-kerberos: test-cp-kerberos-arm64 test-cp-kerberos-amd64

.PHONY: test-cp-jmxterm-arm64
test-cp-jmxterm-arm64:
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_JMXTERM_TEST_LOCATION}

.PHONY: test-cp-jmxterm-amd64
test-cp-jmxterm-amd64:
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_JMXTERM_TEST_LOCATION}

.PHONY: test-cp-jmxterm
test-cp-jmxterm: test-cp-jmxterm-arm64 test-cp-jmxterm-amd64

.PHONY: push-base-local
push-base-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} --all-platforms ${LOCAL_CP_BASE_NEW_IMAGE}

.PHONY: push-cp-kerberos-local
push-cp-kerberos-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_KERBEROS_IMAGE}

.PHONY: push-cp-jmxterm-local
push-cp-jmxterm-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_JMXTERM_IMAGE}


.PHONY: build-images
build-images: build-base test-base push-base-local build-cp-kerberos test-cp-kerberos push-cp-kerberos-local build-cp-jmxterm test-cp-jmxterm push-cp-jmxterm-local

.PHONY: start-local-registry
start-local-registry: shutdown-local-registry
	${IMAGES_BUILD_TOOL} run -d -p 5000:5000 --name local_registry registry:2

.PHONY: shutdown-local-registry
shutdown-local-registry:
	-${IMAGES_BUILD_TOOL} stop -t 2 local_registry
	-${IMAGES_BUILD_TOOL} container rm local_registry

.PHONY: devel
devel: install-bats start-local-registry build-images shutdown-local-registry
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& log_info "Run Complete!"


.PHONY: build-base-ci
build-base-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_BASE_NEW_DOCKER_CONTEXT_DIR}" "${CP_BASE_NEW_COMPONENT}"

.PHONY: build-cp-kerberos-ci
build-cp-kerberos-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KERBEROS_DOCKER_CONTEXT_DIR}" "${CP_KERBEROS_COMPONENT}"

.PHONY: build-cp-jmxterm-ci
build-cp-jmxterm-ci:
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_JMXTERM_DOCKER_CONTEXT_DIR}" "${CP_JMXTERM_COMPONENT}"

.PHONY: publish-images-ci
publish-images-ci:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_BASE_NEW_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_BASE_NEW_IMAGE}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_BASE_NEW_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_KERBEROS_LATEST}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${DOCKER_HUB_CP_BASE_NEW_IMAGE} ${DOCKER_PROTOCOL}${DOCKER_HUB_CP_JMXTERM_LATEST}

.PHONY: build-images-ci
build-images-ci: build-base-ci build-cp-kerberos-ci build-cp-jmxterm-ci

.PHONY: ci
ci: install-bats build-images-ci publish-images-ci
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& log_info "Run Complete!"

.PHONY: clean
clean:
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_BASE_NEW_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_KERBEROS_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_JMXTERM_IMAGE}
