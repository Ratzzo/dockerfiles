USERNAME?=$(shell whoami)
DOCKER=docker
DIRNAME=$(shell basename $(shell pwd))
IMAGENAME=${USERNAME}/${DIRNAME}
RUNDIR=${REPO_ROOT}/run

#${error ${RUNDIR}}

${RUNDIR}:
	mkdir -p ${RUNDIR}