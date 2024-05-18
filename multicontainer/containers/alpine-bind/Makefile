#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=$(MULTICONTAINER_BUILDX_REGISTRY)/ratzzo/alpine-openrc-edge
MULTICONTAINER_BUILD_DEPENDENCIES=alpine-openrc-edge
MULTICONTAINER_RUN_COMMAND=podman run --rm -it -v $(PWD)/shared:/tmp/shared $(MULTICONTAINER_BUILD_IMAGE):linux.amd64-latest
MULTICONTAINER_BUILD_PLATFORMS=linux/amd64

all:
	echo $(MULTICONTAINER_RUN_COMMAND)

include ../../common/common_targets.mk

