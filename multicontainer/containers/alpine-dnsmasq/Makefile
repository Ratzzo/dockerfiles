#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=$(MULTICONTAINER_BUILDX_REGISTRY)/ratzzo/alpine-openrc-only
MULTICONTAINER_BUILD_DEPENDENCIES=alpine-openrc-only
MULTICONTAINER_RUN_COMMAND=podman run --rm -it -v $(PWD)/shared:/tmp/shared registry.ratzzo.net/ratzzo/alpine-dnsmasq:linux.amd64-latest 
MULTICONTAINER_BUILD_PLATFORMS=linux/amd64

all:
	echo $(MULTICONTAINER_RUN_COMMAND)

include ../../common/common_targets.mk

