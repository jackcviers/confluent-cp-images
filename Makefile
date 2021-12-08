# You can override vars like REPOSITORY in a .local.make file
-include .local.make

CONFLUENT_CP_IMAGES_DEVEL_BATS_INSTALL_SCRIPT_LOCATION ?= "./devel/src/main/bash/com/github/jackcviers/installation/scripts/install_bats.sh"

install-bats:
	$(CONFLUENT_CP_IMAGES_DEVEL_BATS_INSTALL_SCRIPT_LOCATION)

make-devel: install-bats
	echo "Should run install-bats first!"
