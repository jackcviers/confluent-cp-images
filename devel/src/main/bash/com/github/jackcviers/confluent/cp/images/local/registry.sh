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

set -e

launch_registry(){
    local build_tool=$1
    local registry_container_name=$2
    local registry_assigned_port=$3

    $build_tool run -d -p $registry_assigned_port:5000 --restart=always --name $registry_container_name registry:2
}

teardown_registry(){
    local build_tool=$1
    local registry_container_name=$2

    if [ "$( ${build_tool} container inspect -f '{{.State.Running}}' ${registry_container_name} )" == "true" ]; then
	$build_tool stop $registry_container_name
	$build_tool rm $registry_container_name
    fi
}
