#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=alpine:3.18
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_BUILD_PLATFORMS=linux/amd64
MULTICONTAINER_RUN_COMMAND=podman run \
-v $$PWD/shared:/tmp/shared \
--network host \
--env SSH_PORT=9991 \
--env SSH_KEEP_KEY=1 \
--rm -it $(MULTICONTAINER_BUILD_IMAGE):linux.amd64-latest

all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
