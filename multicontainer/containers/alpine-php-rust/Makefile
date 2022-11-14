#see common/common_vars.mk for details

include ../../common/common_vars.mk
#SQUASH=--squash
MULTICONTAINER_BUILD_INHERIT_IMAGE=registry.ratzzo.net/ratzzo/alpine-openrc-3.14
#MULTICONTAINER_BUILD_INHERIT_IMAGE=ratzzo/alpine-openrc-3.14
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=podman run \
--privileged \
-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared \
-v $(PWD)/scripts:/opt/$(MULTICONTAINER_BUILD_IMAGE_ESCAPED)_scripts \
--env SSH_PORT=22 \
--env SSH_KEEP_KEY=1 \
-p 0.0.0.0:8888:80 \
-p 0.0.0.0:2222:22 \
--rm -it $(MULTICONTAINER_BUILD_IMAGE)

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
