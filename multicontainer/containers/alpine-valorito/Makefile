#see common/common_vars.mk for details

include ../../common/common_vars.mk
#SQUASH=--squash
REGISTRY_CONTEXT=registry.ratzzo.net
MULTICONTAINER_BUILD_INHERIT_IMAGE=$(REGISTRY_CONTEXT)/ratzzo/alpine-openrc-3.19
#MULTICONTAINER_BUILD_INHERIT_IMAGE=ratzzo/alpine-openrc-3.14
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=podman run \
--privileged \
-v $(PWD)/scripts:/opt/$(MULTICONTAINER_BUILD_IMAGE_ESCAPED)_scripts \
--env TIMEZONE= \
--rm -it $(REGISTRY_CONTEXT)/$(MULTICONTAINER_BUILD_IMAGE):linux.amd64-latest


#-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared

MULTICONTAINER_RUN_COMMAND_=podman run \
--privileged \
--env SSH_PORT \
-p 0.0.0.0:8080:80 \
--rm -it $(MULTICONTAINER_BUILD_IMAGE)

#$(error $(MULTICONTAINER_BUILD_IMAGE))

MULTICONTAINER_BUILD_PLATFORMS=linux/amd64


all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
