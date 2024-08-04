#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=archlinux
MULTICONTAINER_BUILD_DEPENDENCIES=
MULTICONTAINER_RUN_COMMAND=podman run \
-v $(MULTICONTAINER_WORKING_DIR)/shared:/tmp/shared \
--env SSH_PORT=9191 \
--env SSH_KEEP_KEY=1 \
--network host \
--rm -it registry.ratzzo.net/ratzzo/archlinux-node-puppeteer:linux.x86_64-latest


all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk
