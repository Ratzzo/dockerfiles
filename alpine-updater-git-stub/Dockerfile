FROM alpine:edge

ENV UPDATER_GIT_STUB=updater_git_stub
ENV UPDATER_STUB_USER=updater-stub-user
RUN	echo -e "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --no-cache openrc openssh nginx sudo git tcc musl-dev zlib-dev

RUN	export SPASSWORD=$(dd if=/dev/urandom bs=32 count=10 status=none | md5sum | cut -d ' ' -f 1); echo -e "$SPASSWORD\n$SPASSWORD\n" | adduser $UPDATER_STUB_USER && \
	su $UPDATER_STUB_USER -c "cd ~ && git clone https://bitbucket.org/Ratzzo/$UPDATER_GIT_STUB.git && cd $UPDATER_GIT_STUB && tcc -I. -DCRC32TOOL_STANDALONE crc32.c -lz -o crc32" && \
	echo -e "$UPDATER_STUB_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 

#cleanup
RUN apk del --no-cache tcc musl-dev zlib-dev

ADD init.sh /
ADD nginx_config_gen /home/$UPDATER_STUB_USER/

RUN chmod +x /home/$UPDATER_STUB_USER/nginx_config_gen; NGINX_CONF_DEFAULT_SERVER=1 NGINX_CONF_ROOT=/tmp/shared/raw /home/$UPDATER_STUB_USER/nginx_config_gen generate > /etc/nginx/http.d/default.conf && cat /etc/nginx/http.d/default.conf

#fool openrc into thinking it's already started and remove the hwdrivers dependency
RUN mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    rm /etc/init.d/hwdrivers && \
    rc-status && \
	chmod +x init.sh

ENTRYPOINT [ "/init.sh" ]
