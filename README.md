
[//]: # (Copyright 2021-2022 Jack Viers)

[//]: # ( )

[//]: # (   Licensed under the Apache License, Version 2.0 \(the "License"\);)

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

Uses `nerdctl` and `containerd` to build cross-platform images for the confluent community platform. The easiest way to do this is to install [Rancher Desktop] and enable the `containerd` backend.

### Prerequisites

#### Mac

1. [brew](https://brew.sh/)
2.  [Rancher Desktop](https://docs.rancherdesktop.io/)

	```shell
	brew install rancher --no-quarantine
    ```
	
	Give rancher full disk access. Same for ruby.
	
	Create an alias to `nerdctl` from `docker` and create a function named `docker-compose` in your init files (`.bashrc`, `.bash_profile`, `.zshrc`) to run `docker-compose` as `nerdctl compose`:
	
	```shell
	alias docker=nerdctl
	function docker-compose(){
		nerdctl compose $@
	}
	```
	
	Restart Rancher Desktop each time you suspend your machine.
	
3. bash
4. jq
4. make
5. expect (from brew)

   
#### Ubuntu

1. [Rancher Desktop] https://docs.rancherdesktop.io/installation

	Create an alias to `nerdctl` from `docker` and create a function named `docker-compose` in your init files (`.bashrc`, `.bash_profile`, `.zshrc`) to run `docker-compose` as `nerdctl compose`:
	
	```shell
	alias docker=nerdctl
	function docker-compose(){
		nerdctl compose $@
	}
	```
	
	Restart Rancher Desktop each time you suspend your machine.
	
3. bash
4. make
5. expect (from apt)

### Local Development

### CUSTOMIZATION using `.local.make`

You can override the variables defined in the `Makefile` by creating
the git ignored file `.local.make` in the top level directory of this
repo, rather than using environment variables. This file is ignored by
git so allows you to set things only for your local builds.

#### Ubuntu

```Makefile
BATS_INSTALL_SCRIPT_LOCATION=./devel/src/main/bash/com/github/jackcviers/confluent/cp/images/installation/scripts/install_bats_ubuntu.sh
BATS_LIBS_INSTALL_LOCATION=/usr/local/lib
IMAGES_BUILD_TOOL=podman
```

### BUILDING LOCALLY

    $ make devel

### TESTS

Tests are run with [bats](https://bats-core.readthedocs.io/en/stable/), and
exec to get into a container to test for the existence of things. They
can be quite slow to execute. You can skip tests in make devel by
setting `DEVEL_SKIP_TESTS` to `true`.

#### ADDITIONAL CUSTOMIZATION

1. The shell scripts executed by `make` are tested with `bats` where
possible. `make devel` will run the installation for bats on osx using
homebrew. You can change how `bats` is installed by providing a
different bats installation script in the
`BATS_INSTALL_SCRIPT_LOCATION` 
variable. The default behaviour is to see if bats is available on the
system before installing and installing with `homebrew`.

## VERSIONING

If possible, all versions will follow the Confluent CP platform versions.
