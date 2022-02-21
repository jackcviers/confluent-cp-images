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
LABEL version=$VERSION
LABEL name="cp-jmxterm"
LABEL summary="jmxterm image for working with confluent-platform image tests."

USER root
WORKDIR /opt

ADD --chown=appuser:appuser "https://github.com/jiaqi/jmxterm/releases/download/v1.0.2/jmxterm-1.0.2-uber.jar" /opt/jmxterm-1.0.2-uber.jar

USER appuser
WORKDIR /home/appuser
