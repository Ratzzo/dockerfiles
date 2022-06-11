#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=alpine:3.14
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=podman run \
--privileged \
-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared \
-v $(PWD)/scripts:/opt/$(MULTICONTAINER_BUILD_IMAGE_ESCAPED)_scripts \
--env SSH_PORT \
--env SSH_KEEP_KEY=1 \
--network host \
--rm -it $(MULTICONTAINER_BUILD_IMAGE)

MULTICONTAINER_BUILD_PLATFORMS=linux/arm/v7 linux/amd64


all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
