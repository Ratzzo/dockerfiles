REPO_ROOT=$(shell git rev-parse --show-toplevel)

CONTAINER_NAME?=mysql-service

include ${REPO_ROOT}/common/docker.mk

INSIDE_USER=mysql
INSIDE_RUNDIR=/home/${INSIDE_USER}/run


#$(error ${DIRNAME})

all: image
	
image: Dockerfile
	${DOCKER} ${DOCKERPARAMS} build -t ${IMAGENAME} .
	
run: image ${RUNDIR}
	${DOCKER} run --rm --name ${CONTAINER_NAME} -t -d  \
		--volume "${RUNDIR}/${CONTAINER_NAME}:${INSIDE_RUNDIR}:rw" \
		${IMAGENAME} \
		sh
	${DOCKER} exec ${CONTAINER_NAME} chown ${INSIDE_USER}:${INSIDE_USER} ${INSIDE_RUNDIR}

terminate:
	${DOCKER} kill ${CONTAINER_NAME}
		
service-start:
	${DOCKER} start ${CONTAINER_NAME}
	#${DOCKER} exec ${CONTAINER_NAME} su -s /bin/sh ${INSIDE_USER} -c "mysql_install_db --user=${INSIDE_USER} --datadir=${INSIDE_RUNDIR}/data"
	${DOCKER} exec ${CONTAINER_NAME} su -s /bin/sh ${INSIDE_USER} -c "mysqld --skip-grant-tables --datadir=${INSIDE_RUNDIR}/data --socket=${INSIDE_RUNDIR}/my.sock"

service-stop:
	
	