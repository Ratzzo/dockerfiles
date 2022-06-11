#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=alpine:edge
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=podman run --rm -it $(MULTICONTAINER_BUILD_IMAGE)
MULTICONTAINER_BUILD_PLATFORMS=linux/arm/v7 linux/amd64

all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
