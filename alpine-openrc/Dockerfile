FROM arm32v7/alpine:latest

RUN	apk add --no-cache openrc patch
ADD openrc-run.sh.patch /opt/
RUN mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    rm /etc/init.d/hwdrivers && \
    patch -u /lib/rc/sh/openrc-run.sh -i /opt/openrc-run.sh.patch && \
    rc-status
