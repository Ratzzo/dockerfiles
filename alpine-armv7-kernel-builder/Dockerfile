FROM ratzzo/alpine-arm-linux-gnueabihf:latest
#docker build -t ratzzo/alpine-orangepi-zero-kernel-builder .

#remove fltk vestige from gcc image
RUN rm -rf /opt/fltk
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories 
RUN apk add --no-cache build-base git gcc-arm-none-eabi newlib-arm-none-eabi flashrom python2 stlink picocom swig python2-dev qemu-system-arm e2fsprogs-extra ncurses ncurses-dev

#grab static qemu from debian repositories
ENV QEMU_ARM_STATIC_LOCATION=/usr/bin/qemu-arm-static
ENV QEMU_DEB_FILE=qemu-user-static_5.2+dfsg-11_amd64.deb
ENV QEMU_DEB_URL=http://http.us.debian.org/debian/pool/main/q/qemu/${QEMU_DEB_FILE}
ENV QEMU_BINFMT_SCRIPT=qemu-binfmt-conf.sh
ENV QEMU_BINFMT_SCRIPT_URL=https://raw.githubusercontent.com/qemu/qemu/e75941331e4cdc05878119e08635ace437aae721/scripts/${QEMU_BINFMT_SCRIPT}
ENV QEMU_BINFMT_SCRIPT_FULLPATH=/opt/${QEMU_BINFMT_SCRIPT}
RUN cd /opt && wget ${QEMU_BINFMT_SCRIPT_URL} && \
    wget ${QEMU_DEB_URL} && \
    ar -x ${QEMU_DEB_FILE} && \
    cd / && tar xvf /opt/data.tar.xz .${QEMU_ARM_STATIC_LOCATION} && rm /opt/data.tar.xz /opt/${QEMU_DEB_FILE} && chmod +x /opt/${QEMU_BINFMT_SCRIPT}

ENV CACHE_DIR=/opt/shared/cache
ENV BUILD_DIR=/opt/shared/build
ADD scripts/entrypoint /opt/entrypoint
RUN chmod +x /opt/entrypoint

ENTRYPOINT [ "/opt/entrypoint" ]
