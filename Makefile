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
IMAGES_COMPOSE_TOOL ?= "nerdctl compose"

ARM_DOCKER_ARCH = arm64
AMD_DOCKER_ARCH = amd64

AMD_64_TAG = ${VERSION}.${AMD_DOCKER_ARCH}
ARM_64_TAG = ${VERSION}.${ARM_DOCKER_ARCH}
LATEST=latest

CP_BASE_NEW_DOCKER_CONTEXT_DIR = ./devel/src/main/docker/cp-base-new
CP_BASE_NEW_COMPONENT = cp-base-new
CP_BASE_NEW_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-base/cp-base-test.bats
CP_BASE_NEW_MANIFEST_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/manifest-test.bats
CP_BASE_NEW_IMAGE = jackcviers/${CP_BASE_NEW_COMPONENT}
CP_BASE_NEW_VERSION_TAG = ${CP_BASE_NEW_IMAGE}:${VERSION}
CP_BASE_NEW_LATEST_TAG = ${CP_BASE_NEW_IMAGE}:${LATEST}
DOCKER_HUB_CP_BASE_NEW_IMAGE = docker.io/${CP_BASE_NEW_VERSION_TAG}
DOCKER_HUB_CP_BASE_NEW_LATEST = docker.io/${CP_BASE_NEW_LATEST_TAG}
LOCAL_CP_BASE_NEW_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/${CP_BASE_NEW_VERSION_TAG}

CP_KERBEROS_COMPONENT = cp-kerberos
CP_KERBEROS_DOCKER_CONTEXT_DIR = ./devel/src/main/docker/${CP_KERBEROS_COMPONENT}
CP_KERBEROS_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/cp-kerberos/cp-kerberos-test.bats
CP_KERBEROS_IMAGE = jackcviers/${CP_KERBEROS_COMPONENT}
CP_KERBEROS_VERSION_TAG = jackcviers/${CP_KERBEROS_COMPONENT}:${VERSION}
CP_KERBEROS_LATEST_TAG = jackcviers/${CP_KERBEROS_COMPONENT}:${LATEST}
DOCKER_HUB_CP_KERBEROS_IMAGE = docker.io/${CP_KERBEROS_VERSION_TAG}
DOCKER_HUB_CP_KERBEROS_LATEST = docker.io/${CP_KERBEROS_LATEST_TAG}
LOCAL_CP_KERBEROS_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/${CP_KERBEROS_VERSION_TAG}

CP_JMXTERM_COMPONENT = cp-jmxterm
CP_JMXTERM_DOCKER_CONTEXT_DIR = ./devel/src/main/docker/${CP_JMXTERM_COMPONENT}
CP_JMXTERM_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_JMXTERM_COMPONENT}/${CP_JMXTERM_COMPONENT}-test.bats
CP_JMXTERM_IMAGE = jackcviers/${CP_JMXTERM_COMPONENT}
CP_JMXTERM_VERSION_TAG = jackcviers/${CP_JMXTERM_COMPONENT}:${VERSION}
CP_JMXTERM_LATEST_TAG = jackcviers/${CP_JMXTERM_COMPONENT}:${LATEST}
DOCKER_HUB_CP_JMXTERM_IMAGE = docker.io/${CP_JMXTERM_VERSION_TAG}
DOCKER_HUB_CP_JMXTERM_LATEST = docker.io/${CP_JMXTERM_LATEST_TAG}
LOCAL_CP_JMXTERM_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/${CP_JMXTERM_VERSION_TAG}

CP_ZOOKEEPER_COMPONENT = cp-zookeeper
CP_ZOOKEEPER_DOCKER_CONTEXT_DIR = devel/src/main/docker/cp-zookeeper
CP_ZOOKEEPER_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_ZOOKEEPER_COMPONENT}/${CP_ZOOKEEPER_COMPONENT}-test.bats
CP_ZOOKEEPER_STANDALONE_INTEGRATION_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_ZOOKEEPER_COMPONENT}/${CP_ZOOKEEPER_COMPONENT}-standalone-integration-test.bats
CP_ZOOKEEPER_STANDALONE_NEWTWORKING_INTEGRATION_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_ZOOKEEPER_COMPONENT}/${CP_ZOOKEEPER_COMPONENT}-standalone-networking-integration-test.bats
CP_ZOOKEEPER_BRIDGED_NEWTWORKING_INTEGRATION_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_ZOOKEEPER_COMPONENT}/${CP_ZOOKEEPER_COMPONENT}-bridged-networking-integration-test.bats
CP_ZOOKEEPER_IMAGE = jackcviers/${CP_ZOOKEEPER_COMPONENT}
CP_ZOOKEEPER_VERSION_TAG = jackcviers/${CP_ZOOKEEPER_COMPONENT}:${VERSION}
CP_ZOOKEEPER_LATEST_TAG = jackcviers/${CP_ZOOKEEPER_COMPONENT}:${LATEST}
DOCKER_HUB_CP_ZOOKEEPER_IMAGE = docker.io/${CP_ZOOKEEPER_VERSION_TAG}
DOCKER_HUB_CP_ZOOKEEPER_LATEST = docker.io/${CP_ZOOKEEPER_LATEST_TAG}
LOCAL_CP_ZOOKEEPER_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/${CP_ZOOKEEPER_VERSION_TAG}

CP_KAFKACAT_COMPONENT = cp-kafkacat
CP_KAFKACAT_DOCKER_CONTEXT_DIR = devel/src/main/docker/cp-kafkacat
CP_KAFKACAT_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_KAFKACAT_COMPONENT}/${CP_KAFKACAT_COMPONENT}-test.bats
CP_KAFKACAT_IMAGE = jackcviers/${CP_KAFKACAT_COMPONENT}
CP_KAFKACAT_VERSION_TAG = jackcviers/${CP_KAFKACAT_COMPONENT}:${VERSION}
CP_KAFKACAT_LATEST_TAG = jackcviers/${CP_KAFKACAT_COMPONENT}:${LATEST}
DOCKER_HUB_CP_KAFKACAT_IMAGE = docker.io/${CP_KAFKACAT_VERSION_TAG}
DOCKER_HUB_CP_KAFKACAT_LATEST = docker.io/${CP_KAFKACAT_LATEST_TAG}
LOCAL_CP_KAFKACAT_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/${CP_KAFKACAT_VERSION_TAG}

CP_KAFKA_COMPONENT = cp-kafka
CP_KAFKA_DOCKER_CONTEXT_DIR = devel/src/main/docker/cp-kafka
CP_KAFKA_TEST_LOCATION = ./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_KAFKA_COMPONENT}/${CP_KAFKA_COMPONENT}-test.bats
CP_KAFKA_STANDALONE_CONFIG_INTEGRATION_TEST_LOCATION=./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_KAFKA_COMPONENT}/${CP_KAFKA_COMPONENT}-standalone-config-integration-test.bats
CP_KAFKA_STANDALONE_NETWORKING_INTEGRATION_TEST_LOCATION=./devel/src/test/bash/com/github/jackcviers/confluent/cp/images/${CP_KAFKA_COMPONENT}/${CP_KAFKA_COMPONENT}-standalone-networking-integration-test.bats
CP_KAFKA_IMAGE = jackcviers/${CP_KAFKA_COMPONENT}
CP_KAFKA_VERSION_TAG = jackcviers/${CP_KAFKA_COMPONENT}:${VERSION}
CP_KAFKA_LATEST_TAG = jackcviers/${CP_KAFKA_COMPONENT}:${LATEST}
DOCKER_HUB_CP_KAFKA_IMAGE = docker.io/${CP_KAFKA_VERSION_TAG}
DOCKER_HUB_CP_KAFKA_LATEST = docker.io/${CP_KAFKA_LATEST_TAG}
LOCAL_CP_KAFKA_IMAGE = ${LOCALHOST_DOCKER_DOMAIN}/${CP_KAFKA_VERSION_TAG}

DOCKER_PROTOCOL = docker://

.ONESHELL:

.PHONY: install-bats
install-bats:
	echo "install-bats..."
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

.PHONY: build-cp-zookeeper
build-cp-zookeeper: 
	echo "build-cp-zookeeper..."
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_ZOOKEEPER_DOCKER_CONTEXT_DIR}" "${CP_ZOOKEEPER_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-kafkacat
build-cp-kafkacat: 
	echo "build-cp-kafkacat..."
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KAFKACAT_DOCKER_CONTEXT_DIR}" "${CP_KAFKACAT_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: build-cp-kafka
build-cp-kafka: 
	echo "build-cp-kafka..."
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& ${SOURCE_COMMAND} ${BUILD_SCRIPT_SOURCE} \
	&& ${BUILD_COMMAND} "${IMAGES_BUILD_TOOL}" "${VERSION}" "${CP_KAFKA_DOCKER_CONTEXT_DIR}" "${CP_KAFKA_COMPONENT}" "${LOCALHOST_DOCKER_DOMAIN}"

.PHONY: test-base-arm64
test-base-arm64:
	echo "test-base-arm64..."
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_BASE_NEW_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_BASE_NEW_TEST_LOCATION}

.PHONY: test-base-amd64
test-base-amd64:
	echo "test-base-amd64..."
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_BASE_NEW_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_BASE_NEW_TEST_LOCATION}

.PHONY: test-cp-zookeeper-arm64
test-cp-zookeeper-arm64:
	echo "test-cp-zookeeper-arm64..."
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_ZOOKEEPER_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_ZOOKEEPER_TEST_LOCATION}

.PHONY: test-cp-zookeeper-amd64
test-cp-zookeeper-amd64:
	echo "test-cp-zookeeper-amd64..."
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_ZOOKEEPER_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_ZOOKEEPER_TEST_LOCATION}

.PHONY: test-cp-zookeeper-standalone
test-cp-zookeeper-standalone:
	echo "test-cp-zookeeper-standalone..."
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_COMPOSE_TOOL=${IMAGES_COMPOSE_TOOL} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_ZOOKEEPER_IMAGE} \
	JMX_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_ZOOKEEPER_STANDALONE_INTEGRATION_TEST_LOCATION}

.PHONY: test-cp-zookeeper-standalone-network
test-cp-zookeeper-standalone-network:
	echo "test-cp-zookeeper-standalone-network..."
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_COMPOSE_TOOL=${IMAGES_COMPOSE_TOOL} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_ZOOKEEPER_IMAGE} \
	JMX_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_ZOOKEEPER_STANDALONE_NEWTWORKING_INTEGRATION_TEST_LOCATION}

.PHONY: test-cp-zookeeper-cluster-bridged
test-cp-zookeeper-cluster-bridged:
	echo "test-cp-zookeeper-cluster-bridged..."
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_COMPOSE_TOOL=${IMAGES_COMPOSE_TOOL} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_ZOOKEEPER_IMAGE} \
	JMX_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_ZOOKEEPER_BRIDGED_NEWTWORKING_INTEGRATION_TEST_LOCATION}

.PHONY: test-cp-kafkacat-amd64
test-cp-kafkacat-amd64:
	echo "test-cp-kafkacat-amd64..."
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KAFKACAT_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KAFKACAT_TEST_LOCATION}

.PHONY: test-cp-kafkacat-arm64
test-cp-kafkacat-arm64:
	echo "test-cp-kafkacat-arm64..."
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KAFKACAT_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KAFKACAT_TEST_LOCATION}

.PHONY: test-cp-kafka-amd64
test-cp-kafka-amd64:
	echo "test-cp-kafka-amd64..."
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KAFKA_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KAFKA_TEST_LOCATION}

.PHONY: test-cp-kafka-arm64
test-cp-kafka-arm64:
	echo "test-cp-kafka-arm64..."
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KAFKA_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KAFKA_TEST_LOCATION}

.PHONY: test-base
test-base: test-base-arm64 test-base-amd64

.PHONY: test-cp-zookeeper
test-cp-zookeeper: test-cp-zookeeper-amd64 test-cp-zookeeper-arm64 \
	test-cp-zookeeper-standalone \
	test-cp-zookeeper-standalone-network \
	test-cp-zookeeper-cluster-bridged

.PHONY: test-cp-kafkacat
test-cp-kafkacat: test-cp-kafkacat-amd64 test-cp-kafkacat-arm64

.PHONY: test-cp-kafka-standalone-config
test-cp-kafka-standalone-config:
	echo "test-cp-kafka-standalone-config..."
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_COMPOSE_TOOL=${IMAGES_COMPOSE_TOOL} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KAFKA_IMAGE} \
	JMX_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	KAFKACAT_IMAGE=${LOCAL_CP_KAFKACAT_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KAFKA_STANDALONE_CONFIG_INTEGRATION_TEST_LOCATION}

.PHONY: test-cp-kafka-standalone-networking
test-cp-kafka-standalone-networking:
	echo "test-cp-kafka-standalone-networking..."
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_COMPOSE_TOOL=${IMAGES_COMPOSE_TOOL} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KAFKA_IMAGE} \
	JMX_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	KAFKACAT_IMAGE=${LOCAL_CP_KAFKACAT_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KAFKA_STANDALONE_NETWORKING_INTEGRATION_TEST_LOCATION}

.PHONY: test-cp-kafka
test-cp-kafka: test-cp-kafka-amd64 test-cp-kafka-arm64 test-cp-kafka-standalone-config test-cp-kafka-standalone-networking

.PHONY: test-cp-kerberos-arm64
test-cp-kerberos-arm64:
	echo "test-cp-kerberos-arm64..."
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KERBEROS_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KERBEROS_TEST_LOCATION}

.PHONY: test-cp-kerberos-amd64
test-cp-kerberos-amd64:
	echo "test-cp-kerberos-amd64..."
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_KERBEROS_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_KERBEROS_TEST_LOCATION}

.PHONY: test-cp-kerberos
test-cp-kerberos: test-cp-kerberos-arm64 test-cp-kerberos-amd64
	echo "test-cp-kerberos..."

.PHONY: test-cp-jmxterm-arm64
test-cp-jmxterm-arm64:
	echo "test-cp-jmxterm-arm64..."
	ARCH=${ARM_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_JMXTERM_TEST_LOCATION}

.PHONY: test-cp-jmxterm-amd64
test-cp-jmxterm-amd64:
	echo "test-cp-jmxterm-amd64..."
	ARCH=${AMD_DOCKER_ARCH} \
	BATS_LIBS_INSTALL_LOCATION=${BATS_LIBS_INSTALL_LOCATION} \
	BATS_BUILD_TOOL=${IMAGES_BUILD_TOOL} \
	BATS_IMAGE=${LOCAL_CP_JMXTERM_IMAGE} \
	${TIME_COMMAND} ${BATS_COMMAND} ${CP_JMXTERM_TEST_LOCATION}

.PHONY: test-cp-jmxterm
test-cp-jmxterm: test-cp-jmxterm-arm64 test-cp-jmxterm-amd64
	echo "test-cp-jmxterm..."

.PHONY: push-base-local
push-base-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_BASE_NEW_IMAGE}

.PHONY: push-cp-kerberos-local
push-cp-kerberos-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_KERBEROS_IMAGE}

.PHONY: push-cp-jmxterm-local
push-cp-jmxterm-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_JMXTERM_IMAGE}

.PHONY: push-cp-zookeeper-local
push-cp-zookeeper-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_ZOOKEEPER_IMAGE}

.PHONY: push-cp-kafkacat-local
push-cp-kafkacat-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_KAFKACAT_IMAGE}

.PHONY: push-cp-kafka-local
push-cp-kafka-local:
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${LOCAL_CP_KAFKA_IMAGE}

.PHONY: build-images

build-images: build-base test-base push-base-local build-cp-kerberos \
	test-cp-kerberos push-cp-kerberos-local build-cp-jmxterm \
	test-cp-jmxterm push-cp-jmxterm-local build-cp-zookeeper \
	test-cp-zookeeper push-cp-zookeeper-local build-cp-kafkacat \
	test-cp-kafkacat push-cp-kafkacat-local build-cp-kafka \
	test-cp-kafka push-cp-kafka-local

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

.PHONY: publish-images-ci
publish-images-ci:
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_BASE_NEW_IMAGE} ${CP_BASE_NEW_VERSION_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_BASE_NEW_IMAGE} ${CP_BASE_NEW_LATEST_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_BASE_NEW_LATEST_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_BASE_NEW_VERSION_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_KERBEROS_IMAGE} ${CP_KERBEROS_VERSION_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_KERBEROS_IMAGE} ${CP_KERBEROS_LATEST_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_KERBEROS_VERSION_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_KERBEROS_LATEST_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_JMXTERM_IMAGE} ${CP_JMXTERM_VERSION_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_JMXTERM_IMAGE} ${CP_JMXTERM_LATEST_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_JMXTERM_VERSION_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_JMXTERM_LATEST_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_ZOOKEEPER_IMAGE} ${CP_ZOOKEEPER_VERSION_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_ZOOKEEPER_IMAGE} ${CP_ZOOKEEPER_LATEST_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_ZOOKEEPER_VERSION_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_ZOOKEEPER_LATEST_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_KAFKACAT_IMAGE} ${CP_KAFKACAT_VERSION_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_KAFKACAT_IMAGE} ${CP_KAFKACAT_LATEST_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_KAFKACAT_VERSION_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_KAFKACAT_LATEST_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_KAFKA_IMAGE} ${CP_KAFKA_VERSION_TAG}
	${IMAGES_BUILD_TOOL} tag ${LOCAL_CP_KAFKA_IMAGE} ${CP_KAFKA_LATEST_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_KAFKA_VERSION_TAG}
	${IMAGES_BUILD_TOOL} ${DOCKER_PUSH_COMMAND} ${CP_KAFKA_LATEST_TAG}

.PHONY: ci
ci: devel publish-images-ci
	${SOURCE_COMMAND} ${COLORS_SOURCE} \
	&& log_info "Run Complete!"

.PHONY: clean
clean:
	echo "clean..."
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_BASE_NEW_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_KERBEROS_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_JMXTERM_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_ZOOKEEPER_IMAGE}
	-${IMAGES_BUILD_TOOL} ${DOCKER_REMOVE_IMAGE_COMMAND} ${LOCAL_CP_KAFKA_IMAGE}
