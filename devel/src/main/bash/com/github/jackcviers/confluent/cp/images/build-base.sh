#!/bin/bash


image_base_name="jackcviers"
image_component_name="cp-base-new"
image_name=${image_base_name}/${image_component_name}

build_base(){
    local build_tool=$1
    local version=$2
    local docker_context_path=$3
    
    for arch  in amd64 arm64v8; do
	local tag="${image_name}:${version}.${arch}"
	local docker_file="${docker_context_path}/Dockerfile.${arch}"
	log_info "Building ${tag} from ${docker_file} with ${build_tool}"
	$build_tool build \
	      --arch=amd64 \
	      -t ${image_name}:${version}.${arch} \
	      --build-arg ARCH=${arch} \
	      --build-arg VERSION=$version \
	      -f $docker_file 
    done
}
