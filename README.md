
[//]: # (Copyright 2021 Jack Viers)

[//]: # ( )

[//]: # (   Licensed under the Apache License, Version 2.0 (the "License");)

[//]: # (   you may not use this file except in compliance with the License.)

[//]: # (   You may obtain a copy of the License at)

[//]: # ( )

[//]: # (       http://www.apache.org/licenses/LICENSE-2.0)

[//]: # ( )

[//]: # (   Unless required by applicable law or agreed to in writing, software)

[//]: # (   distributed under the License is distributed on an "AS IS" BASIS,)

[//]: # (   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.)

[//]: # (   See the License for the specific language governing permissions and)

[//]: # (   limitations under the License.)
   
# confluent-cp-images
A repository of UTD docker images for the confluent community images

## Motivation 

The [Confluent
cp-images](https://github.com/confluentinc/cp-docker-images#deprecation-notice)
have been deprecated. The new cp-base is not built for cross-platform
distribution, and [Confluent have locked the issue about when it's
coming (after being open for a year) for internal use
only](https://github.com/confluentinc/common-docker/issues/117#issuecomment-948789717)
and the build process is not
[straightforward](https://github.com/confluentinc/common-docker/issues/171)
or working for me.

The goal is to have a working, multi-arch deployment of all the
components supported in the cp-images repository, capable of being
built on Mac M1 without the non-free Docker Desktop. The goal is to
support only the components themselves, not any ancillary software.

It is also a goal to try to stay up to date with the latest
*publically available* releases from Confluent. This means that this
repo will only publish images *AFTER* the public release is
available. If you need a particular version, please file an <issue> or
make an MR.

## Build

This project will attempt to do everything via `make` and `bash`, in a
compatible manner for `docker` without the experimental `buildx`
support. I have `podman` running in `qemu` on a mac M1. Docker Desktop
is non-free now, so builds have to be docker command compatible
without relying upon special features enabled by Docker Desktop in
order to be truly portable for maintainers and committers on multiple
platforms.

I may switch to using sbt, since I am a scala developer and the kafka
components are maven dependencies. But I will update this readme with
the necessary installation instructions if necessary.

### Prerequisites

1. Docker-compatible client/container engine, such as [podman](https://podman.io/).
2. bash
3. make
4. A docker repository running somewhere other than docker-hub, for
   local development only. See `Local Development` for additional
   instructions.
5. brew (for bats installation on OSX). You may override the
   installation script for bats to not use homebrew. See `ADDITIONAL
   CUSTOMIZATION` below.


### Switching to an alternative build tool, like podman, from docker

Export the full path to the alternative tool as the `IMAGES_BUILD_TOOL` before running `make`.

    $ export IMAGES_BUILD_TOOL=/opt/homebrew/bin/podman
    $ make

This will be picked up by the Makefile as an argument. It will then be
used to run all subsequent docker build commands.

### Local Development

### Using a non-public docker repository

To create cross-platform docker images, this project does not use
`buildx`. This requires that images be published to a repository and
tagged with the architecture version so that a manifest add command
can pull the manifest and add it to the cross-platform manifest at the
proper tag. As such, you will want to have a local repository
available for use during development. I use [the open source docker
registry](https://docs.docker.com/registry/deploying/). `make-devel-local-registry`
will start one for you.

If you are running outside of docker-desktop docker, you will also
need to enable cross-platform capabilities on the virtual machine
providing docker capability (https://edofic.com/posts/2021-09-12-podman-m1-amd64/).

### BUILDING LOCALLY

    $ make make-devel

### TESTS

Tests are run with [bats](https://github.com/sstephenson/bats), and
exec to get into a container to test for the existence of things. They
can be quite slow to execute. You can skip tests in make devel by
setting `DEVEL_SKIP_TESTS` to `true`.

#### ADDITIONAL CUSTOMIZATION

1. The shell scripts executed by `make` are tested with `bats` where
possible. `make devel` will run the installation for bats on osx using
homebrew. You can change how `bats` is installed by providing a
different bats installation script in the
`BATS_INSTALL_SCRIPT_LOCATION` environment
variable. The defalut behavior is to see if bats is available on the
system before installing and installing with `homebrew`.

### CUSTOMIZATION using `.local.make`

You can override the variables defined in the `Makefile` by creating
the git ignored file `.local.make` in the top level directory of this
repo, rather than using environment variables. This file is ignored by
git so allows you to set things only for your local builds.

## VERSIONING

If possible, all versions will follow the Confluent CP platform versions.
