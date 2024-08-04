#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=mcr.microsoft.com/mssql/server:2019-latest
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=podman run --rm -it \
-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared \
-v $(MULTICONTAINER_WORKING_DIR)/persist/shadow:/etc/shadow \
registry.ratzzo.net/ratzzo/mssql-server:linux.x86_64-latest


#MULTICONTAINER_RUN_COMMAND=docker run \
#--privileged \
#-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared \
#--env SSH_PORT \
#--network host \
#--rm -it $(MULTICONTAINER_BUILD_IMAGE)


all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
