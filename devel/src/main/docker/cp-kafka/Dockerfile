# Copyright 2022 Jack Viers

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG UPSTREAM_REPOSITORY=docker.io
ARG VERSION
FROM --platform=${BUILDPLATFORM} ${UPSTREAM_REPOSITORY}/jackcviers/cp-base-new:${VERSION}

LABEL maintainer="jackcviers@gmail.com"
LABEL version=${VERSION}
LABEL name="cp-kafka"
LABEL summary="Confluent Community Platform Compatible Kafka image."

ENV LANG="C.UTF-8"
ENV CUB_CLASSPATH='"/usr/share/java/cp-base-new/*"'
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPONENT=kafka

USER root

RUN apt install -y software-properties-common \
    && apt update \
    && apt upgrade -y \
    && wget wget https://packages.confluent.io/deb/7.0/pool/main/c/confluent-kafka/confluent-kafka_7.0.1-1_all.deb \
    && dpkg -i confluent-kafka_7.0.1-1_all.deb \
    && rm -rf confluent-kafka_7.0.1-1_all.deb

RUN mkdir -p /var/lib/${COMPONENT}/data /etc/${COMPONENT}/secrets /var/run/krb5 \
    && chown -R appuser:root /var/lib/${COMPONENT} /etc/${COMPONENT} /var/log/${COMPONENT} /var/log/confluent /var/lib/zookeeper /var/run/krb5 \
    && chmod -R 776 /var/lib/${COMPONENT} /etc/${COMPONENT} /var/log/${COMPONENT} /var/log/confluent /var/lib/zookeeper /var/run/krb5 \
    && chmod -R 777 /usr/share/java/ # necessary to run as random user

COPY --chown=appuser:appuser include/etc/confluent/docker /etc/confluent/docker

VOLUME [ "/var/lib/${COMPONENT}/data", "/etc/${COMPONENT}/secrets", "/var/run/krb5" ]

USER appuser

CMD ["/etc/confluent/docker/run"]
