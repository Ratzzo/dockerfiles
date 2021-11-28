#boilerplate stuff
FROM alpine:edge

#append old setup to setup chain
RUN touch /opt/setup_chain && \
    echo DOCKER_IMAGE=$DOCKER_IMAGE >> /opt/setup_chain && \
    echo DOCKER_SETUP=$DOCKER_SETUP >> /opt/setup_chain && \
    echo DOCKER_EP=$DOCKER_EP >> /opt/setup_chain && \
    echo ${DOCKER_SETUP} >> /opt/setup_chain && \
    chmod +x /opt/setup_chain || true
    
ENV DOCKER_IMAGE=ratzzo/test_container1
ENV DOCKER_SETUP=/opt/ratzzo_test_container1_scripts/setup
ENV DOCKER_EP=/opt/ratzzo_test_container1_scripts/entrypoint
ADD scripts /opt/ratzzo_test_container1_scripts


RUN env

ENTRYPOINT sh -c "/opt/setup_chain; cd $(dirname $DOCKER_EP); $DOCKER_EP"
