#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=registry.ratzzo.net/ratzzo/alpine-openrc-edge
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=podman run \
--name ddclient \
--privileged \
-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared \
--network host \
--rm -it $(MULTICONTAINER_BUILDX_REGISTRY)/$(MULTICONTAINER_BUILD_IMAGE):linux.x86_64-latest ddclient ddclient -file /tmp/shared/ddclient_config6 -daemon 600 -foreground


all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
