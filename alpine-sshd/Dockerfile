FROM alpine:edge
#docker build . -t ratzzo/alpine-sshd

ENV DOCKER_CONTAINER=1
RUN	echo -e "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --no-cache openrc openssh sudo #tcc musl-dev zlib-dev

ADD scripts /opt/scripts

RUN mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    rm /etc/init.d/hwdrivers && \
    rc-status

ENTRYPOINT [ "/opt/scripts/entrypoint" ]



