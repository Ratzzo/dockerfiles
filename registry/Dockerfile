FROM registry:2
#docker build . -t ratzzo/registry

ENV DOCKER_IMAGE=ratzzo/registry
RUN apk add --no-cache openrc openssh sudo nginx apache2-utils #tcc musl-dev zlib-dev

ADD scripts /opt/scripts
COPY readme /opt/scripts/readme

RUN mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    rm /etc/init.d/hwdrivers && \
    rc-status

CMD [ "/opt/scripts/show_readme" ]



