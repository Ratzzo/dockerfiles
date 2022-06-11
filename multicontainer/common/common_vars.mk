#base dir as parent folder of this script
MULTICONTAINER_BASE_DIR:=$(shell cd ..; pwd)

#container name as the current folder name.
#can be overriden to build with a different name
MULTICONTAINER_WORKING_DIR:=$(shell pwd)
MULTICONTAINER_IMAGE_NAME:=$(shell basename $(MULTICONTAINER_WORKING_DIR))

include ../../common/common_config.mk

ifeq ($(MULTICONTAINER_DOCKER_USERNAME),)
$(error Please define MULTICONTAINER_DOCKER_USERNAME in common_config.mk)
endif

ifeq  ($(MULTICONTAINER_BUILDX_REGISTRY),)
$(error Please define MULTICONTAINER_BUILDX_REGISTRY in common_config.mk)
endif

## stuff that should be defined in containers/*/Makefile ##

#other containers that must be built to allow the correct build of this one 
MULTICONTAINER_BUILD_DEPENDENCIES?=

#
MULTICONTAINER_BUILD_INHERIT_IMAGE?=

MULTICONTAINER_BUILD_JOBS?=4

#replace : and / with _
MULTICONTAINER_BUILD_INHERIT_IMAGE_ESCAPED=$(subst /,_,$(subst :,_,$(MULTICONTAINER_BUILD_INHERIT_IMAGE)))

MULTICONTAINER_BUILD_IMAGE?=$(MULTICONTAINER_DOCKER_USERNAME)/$(MULTICONTAINER_IMAGE_NAME)

#replace : and / with _
MULTICONTAINER_BUILD_IMAGE_ESCAPED=$(subst /,_,$(subst :,_,$(MULTICONTAINER_BUILD_IMAGE)))

#if platform not defined use host platform

#replace : and / with _
MULTICONTAINER_BUILD_IMAGE_ESCAPED=$(subst /,_,$(subst :,_,$(MULTICONTAINER_BUILD_IMAGE)))

#the command used for running this container
MULTICONTAINER_RUN_COMMAND?=
MULTICONTAINER_QUICK_RUN_COMMAND?=$(MULTICONTAINER_RUN_COMMAND)

MULTICONTAINER_BUILD_OUTDIR?=out

MULTICONTAINER_BUILD_PLATFORMS?=$(shell OS=$$(uname -o); 		\
					if [ "$$OS" == "GNU/Linux" ]; 	\
					then 				\
						echo -n "linux/"; 	\
					else 				\
						echo -n "$$OS/"; 	\
					fi; 				\
					echo -n $$(uname -m);		\
					) 

MULTICONTAINER_BUILD_PLATFORMS_ESCAPED=$(subst /,.,$(MULTICONTAINER_BUILD_PLATFORMS))

MULTICONTAINER_BUILD_PLATFORM_TARGETS=$(foreach dep,$(MULTICONTAINER_BUILD_PLATFORMS_ESCAPED),$(MULTICONTAINER_BUILD_OUTDIR)/$(dep)_built)

MULTICONTAINER_BUILD_PLATFORM_DOCKERFILE_IN_FILES=$(foreach dep,$(MULTICONTAINER_BUILD_PLATFORMS_ESCAPED),Dockerfile.$(dep).in)
MULTICONTAINER_BUILD_PLATFORM_DOCKERFILE_OUT_FILES=$(foreach dep,$(MULTICONTAINER_BUILD_PLATFORMS_ESCAPED),Dockerfile.$(dep))

#check for file existence. If not default to Dockerfile.in
MULTICONTAINER_BUILD_PLATFORM_DOCKERFILE_IN_TARGETS=$(foreach dep, $(MULTICONTAINER_BUILD_PLATFORM_DOCKERFILE_IN_FILES), $(shell DEP=$(dep); if [ ! -f "$$DEP" ]; then echo -n "Dockerfil%.in"; else echo -n "$$DEP"; fi))

MULTICONTAINER_BUILD_PLATFORM_DOCKERFILE_OUT_TARGETS=$(foreach dep, $(MULTICONTAINER_BUILD_PLATFORM_DOCKERFILE_OUT_FILES), $(shell DEP=$(dep); if [ ! -f "$$DEP.in" ]; then echo -n "$(MULTICONTAINER_BUILD_OUTDIR)/Dockerfile"; else echo -n "$(MULTICONTAINER_BUILD_OUTDIR)/$$DEP"; fi))

MULTICONTAINER_BUILD_SCRIPTSDIR?=scripts

MULTICONTAINER_BUILD_DEPCHECK_OUTDIR?=$(MULTICONTAINER_BUILD_OUTDIR)/depcheck

MULTICONTAINER_BUILD_DEPENDENCIES_CHECK_TARGETS=$(foreach dep,$(MULTICONTAINER_BUILD_DEPENDENCIES),$(MULTICONTAINER_BUILD_DEPCHECK_OUTDIR)/$(dep))



