#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=$(MULTICONTAINER_BUILDX_REGISTRY)/ratzzo/test_container1
MULTICONTAINER_BUILD_DEPENDENCIES=test_container1
MULTICONTAINER_RUN_COMMAND=podman run --rm -it $(MULTICONTAINER_BUILDX_REGISTRY)/$(MULTICONTAINER_BUILD_IMAGE)
MULTICONTAINER_BUILD_PLATFORMS=linux/arm/v7 linux/amd64

all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk

