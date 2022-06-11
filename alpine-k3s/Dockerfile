FROM alpine:edge
#docker build . -t ratzzo/alpine-k3s

ENV UPDATER_GIT_STUB=k3
ENV UPDATER_STUB_USER=k3
RUN	echo -e "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --no-cache openrc openssh sudo k3s git #tcc musl-dev zlib-dev
#
RUN	export SPASSWORD=$(dd if=/dev/random bs=32 count=10 status=none | md5sum | cut -d ' ' -f 1); echo -e "$SPASSWORD\n$SPASSWORD\n" | adduser $UPDATER_STUB_USER && \
	su $UPDATER_STUB_USER -c "echo $USER" && \
	echo -e "$UPDATER_STUB_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 
#
##cleanup
#RUN apk del --no-cache tcc musl-dev zlib-dev
#
ADD init.sh /
#ADD nginx_config_gen /home/$UPDATER_STUB_USER/
#
#RUN chmod +x /home/$UPDATER_STUB_USER/nginx_config_gen; NGINX_CONF_DEFAULT_SERVER=1 NGINX_CONF_ROOT=/tmp/shared/raw /home/$UPDATER_STUB_USER/nginx_config_gen generate > /etc/nginx/http.d/default.conf && cat /etc/nginx/http.d/default.conf
#
#fool openrc into thinking it's already started and remove the hwdrivers dependency
RUN mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    rm /etc/init.d/hwdrivers && \
    rc-status && \
	chmod +x init.sh

ENTRYPOINT [ "/init.sh" ]
