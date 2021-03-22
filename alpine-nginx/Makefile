REPO_ROOT=$(shell git rev-parse --show-toplevel)

CONTAINER_NAME?=nginx-service
BIND_PORT?=8090
INTERNAL_BIND_PORT?=8080
include ${REPO_ROOT}/common/docker.mk

#variables passed to the image at build time
INTERNAL_UID=$(shell id -u)
INTERNAL_GID=$(shell id -g)
INTERNAL_USER=http
INTERNAL_RUNDIR=/home/${INTERNAL_USER}/run
INTERNAL_CONFIG_DIR=${INTERNAL_RUNDIR}/config

#docker exec nginx-service  su -s /bin/sh http -c "fcgiwrap -s unix:/home/http/run/fcgiwrap.socket"
RUNAS_INTERNAL=${DOCKER} exec ${CONTAINER_NAME} su -s /bin/sh ${INTERNAL_USER} -c

NGINX_DIRECTIVES=pid ${INTERNAL_RUNDIR}/nginx.pid; error_log stderr;
NGINX_OPTIONS=-g '${NGINX_DIRECTIVES}' -c ${INTERNAL_CONFIG_DIR}/nginx.conf -p ${INTERNAL_RUNDIR}


#$(error ${DIRNAME})

all: image
	
image: Dockerfile
	${DOCKER} ${DOCKERPARAMS} build \
		--build-arg INTERNAL_RUNDIR=${INTERNAL_RUNDIR} \
		--build-arg INTERNAL_USER=${INTERNAL_USER} \
		--build-arg INTERNAL_CONFIG_DIR=${INTERNAL_CONFIG_DIR}	\
		-t ${IMAGENAME} .

#starts the container
run: image ${RUNDIR}
	${DOCKER} run --rm --name ${CONTAINER_NAME} -t -d  \
		--volume "${RUNDIR}/${CONTAINER_NAME}:${INTERNAL_RUNDIR}:rw" \
		-p ${BIND_PORT}:${INTERNAL_BIND_PORT}/tcp	\
		${IMAGENAME} \
		sh
	${DOCKER} exec ${CONTAINER_NAME} adduser -D -s /sbin/nologin -u ${INTERNAL_UID} ${INTERNAL_USER}
	${DOCKER} exec ${CONTAINER_NAME} chown ${INTERNAL_USER}:${INTERNAL_USER} ${INTERNAL_RUNDIR}
	${RUNAS_INTERNAL} "rm -f ${INTERNAL_RUNDIR}/access_log && mkfifo ${INTERNAL_RUNDIR}/access_log"
	
#terminates the container (removes it from docker ps)
terminate:
	${RUNAS_INTERNAL} "rm -f ${INTERNAL_RUNDIR}/access_log"
	${DOCKER} kill ${CONTAINER_NAME} 

#setups the service ie: copies the config from /etc to the run folder
service-setup:
	${RUNAS_INTERNAL} "cp -r /etc/nginx ${INTERNAL_CONFIG_DIR} && mkdir ${INTERNAL_RUNDIR}/public && touch ${INTERNAL_RUNDIR}/public/test && mkdir ${INTERNAL_RUNDIR}/logs"
		
#starts the service inside the container
start:
	${DOCKER} start ${CONTAINER_NAME}
	${RUNAS_INTERNAL} "nginx ${NGINX_OPTIONS} &"
	${RUNAS_INTERNAL} "cat ${INTERNAL_RUNDIR}/access_log"
	
	
#stops the service inside the container
stop:
	${RUNAS_INTERNAL} "nginx -s stop ${NGINX_OPTIONS}"
	
#deletes nonvolatile data
clean: 
	rm -rf ${RUNDIR}/${CONTAINER_NAME}