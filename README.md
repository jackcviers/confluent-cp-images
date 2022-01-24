
[//]: # (Copyright 2021 Jack Viers)

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

#### Mac

1. [brew](https://brew.sh/)
2.  [podman](https://podman.io/)

Enable remote ssh login for your user on macOS: 

##### Under `System Preferences > Sharing`:

- [x] Remote Login

- [x] Allow full disk access for remote users

- [x] Only these users
        
		*Administrators*

##### Install podman 3.4.2

Version 3.4.4 in the podman tap cannot build images on macOS as it
errors out with an incorrect vm temp directory location (stat error).

You must give the vm at least 2 cpus, or it will
fail in building `cp-base-new` during `pynacl` wheel compilation.

	```shell
	brew tap-new $USER/local-podman
	brew extract --version=3.4.2 podman $USER/local-podman
	HOMEBREW_NO_AUTO_UPDATE=1 brew install $USER/local-podman/podman@3.4.2
	ln -s /opt/homebrew/opt/podman@3.4.2/libexec /opt/homebrew/opt/podman/
    podman machine init --disk-size 50 --memory <round_to_nearest_GB_in_MB(total_system_memory / 2)> --cpus <floor(NUM_CPUS / 2)> # example I have 16 GB RAM then it's 8192 for memory. I have 9 cores so it's 4 for cpu.
	podman machine start
    podman machine ssh
    sudo -i
    rpm-ostree install qemu-user-static
    systemctl reboot
    ```
3. bash
4. jq
4. make
4. A docker repository running somewhere other than docker-hub, for
   local development only. See `Local Development` for additional
   instructions.
5. *MAC ONLY* *Every time you reboot the podman machine*, you must run the
   following:

   Replace `<MAC_USER>` with your macos username, and `<macos_ip>` is
   the ip address under `System Preferences > Sharing`.
   
	```shell
   	podman machine ssh
	sudo -i
	mkdir -p /mnt/Users
	chown -R core:root /mnt/Users
	sshfs <MAC_USER>@<macos_ip>:/Users /mnt/Users
	<enter your password at prompt>
	exit
	```
	
   You will then have to use the absolute VM address of whatever you
   have under the local /Users directory as the volume path. So to
   read and write to your `HOME` from a busybox, for example:
   
   ```shell
   podman run -it --rm -v /mnt/Users/<username>/:/<username> busybox /bin/bash
   ```

##### Troubleshooting Build on M1

If your podman fails in make make-devel, you may need to [install the
patched version of
podman](https://edofic.com/posts/2021-09-12-podman-m1-amd64/).
   
#### Ubuntu

1. [brew](https://brew.sh/)
2.  [podman](https://podman.io/)

    ```shell
	. /etc/os-release
	echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
	curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
	sudo apt update
	sudo apt -y upgrade
	sudo apt install -y podman	
    ```
3. qemu 5

	```shell
	sudo add-apt-repository ppa:jacob/virtualisation
	sudo apt update
	sudo apt install -y qemu qemu-user-static
	```

3. bash
4. make
4. A docker repository running somewhere other than docker-hub, for
   local development only. See `Local Development` for additional
   instructions.

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

    $ make make-devel

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
