FROM alpine:latest

ARG INTERNAL_RUNDIR
ARG	INTERNAL_USER
ARG INTERNAL_CONFIG_DIR

ADD default_config /etc/nginx
RUN	apk add --no-cache nginx screen fcgiwrap
