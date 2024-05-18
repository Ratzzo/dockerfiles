#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=alpine:edge
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_BUILD_PLATFORMS=linux/amd64
MULTICONTAINER_RUN_COMMAND=podman run \
-v $$PWD/shared:/tmp/shared \
--network host \
--rm -it $(MULTICONTAINER_BUILD_IMAGE):linux.amd64-latest

all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
