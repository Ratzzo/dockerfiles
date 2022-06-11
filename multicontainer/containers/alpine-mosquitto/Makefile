#see common/common_vars.mk for details

include ../../common/common_vars.mk

MULTICONTAINER_BUILD_INHERIT_IMAGE=ratzzo/alpine-sshd
MULTICONTAINER_BUILD_DEPENDENCIES=alpine-sshd
MULTICONTAINER_RUN_COMMAND=docker run --rm -it $(MULTICONTAINER_BUILD_IMAGE)


include ../../common/common_targets.mk
