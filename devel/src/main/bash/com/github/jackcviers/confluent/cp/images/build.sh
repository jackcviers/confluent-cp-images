#!/bin/bash

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


build(){
    local build_tool=$1
    local version=$2
    local docker_context_path=$3
    local repository="docker.io"
    local image_component_name=$4
    local image_base_name="jackcviers"
    local insecure=""
    echo "==================================================================="
    echo "REPOSITORY IS: $5"
    echo "ARGS IS: $0"
    echo "==================================================================="

    if [[ ! -z "$5" ]]; then
	repository=$5
    fi
    
    if [[ "${repository}" = "localhost:5000" ]]; then
	insecure="--insecure-registry"
    fi

    local image_name=${repository}/${image_base_name}/${image_component_name}
    local tag="${image_name}:${version}"
    local docker_file="${docker_context_path}/Dockerfile"
    log_info "Building with: 
              $build_tool build $insecure \
	        --platform=linux/amd64,linux/arm64 \
		--progress=tty \
		-t ${image_name}:${version} \
		--build-arg ARCH=\"\" \
		--build-arg VERSION=$version \
		--build-arg UPSTREAM_REPOSITORY=$repository \
		-f $docker_file \
		${docker_context_path}"
    $build_tool build \
		--platform=amd64,arm64 \
		--insecure-registry \
		--progress=plain \
		-t ${image_name}:${version} \
		--build-arg ARCH="" \
		--build-arg VERSION=$version \
		--build-arg UPSTREAM_REPOSITORY=$repository \
		-f $docker_file \
		${docker_context_path}
}
