#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=ratzzo/test_container1
MULTICONTAINER_BUILD_DEPENDENCIES=test_container1
MULTICONTAINER_RUN_COMMAND=docker run --rm -it $(MULTICONTAINER_BUILD_IMAGE)

all:
	echo $(MULTICONTAINER_BASE_DIR)

include ../../common/common_targets.mk

