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
LABEL name="cp-zookeeper"
LABEL summary="Confluent Community Platform Compatible Zookeeper image."

ENV LANG="C.UTF-8"
ENV CUB_CLASSPATH='"/usr/share/java/cp-base-new/*"'
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPONENT=zookeeper

USER root

RUN apt update \
	&& apt install -y software-properties-common \
	&& wget -qO - https://packages.confluent.io/deb/7.0/archive.key | apt-key add -\
	&& add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/7.0 stable main" \
	&& add-apt-repository "deb https://packages.confluent.io/clients/deb buster main" \
	&& apt update \
	&& apt install -y confluent-kafka \
	&& mkdir -p /var/lib/zookeeper \
	&& chown -R appuser:root /var/lib/zookeeper \
	&& mkdir -p /var/lib/zookeeper/data \
	/var/lib/zookeeper/log \
	/etc/zookeeper/secrets \
	/etc/kafka \
	/var/log/kafka \
	/var/log/confluent \
	/var/lib/kafka \
	/var/run/krb5 \
	&& chown -R appuser:root /var/lib/zookeeper/data \
	/var/lib/zookeeper/log \
	/etc/zookeeper/secrets \
	/etc/kafka /var/log/kafka \
	/var/log/confluent /var/lib/kafka \
	/var/run/krb5 \
	&& chmod -R 776 /var/lib/zookeeper/data \
	/var/lib/zookeeper/log \
	/etc/zookeeper/secrets \
	/etc/kafka /var/log/kafka \
	/var/log/confluent \
	/var/lib/kafka \
	/var/run/krb5 \
	&& apt-get autoremove -y \
	&& apt-get clean -y

VOLUME ["/var/lib/zookeeper/data", "/var/lib/zookeeper/log", "/etc/zookeeper/secrets", "/var/run/krb5"]

COPY --chown=appuser:appuser include/etc/confluent/docker /etc/confluent/docker

USER appuser

CMD ["/etc/confluent/docker/run"]

