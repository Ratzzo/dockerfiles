#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=alpine:edge
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=docker run \
--privileged \
-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared \
--env SSH_PORT \
--network host \
--rm -it $(MULTICONTAINER_BUILD_IMAGE)


all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
