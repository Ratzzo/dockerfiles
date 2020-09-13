FROM ratzzo/alpine-gcc

RUN apk add --no-cache automake gettext bison flex gperf intltool libtool lzip openssl xz p7zip gdk-pixbuf gawk python3 rsync && mkdir -p /opt/shared

RUN mkdir -p /opt/shared/ && cd /opt/shared && wget https://musl.cc/armv7l-linux-musleabihf-cross.tgz
RUN cd /opt/shared && tar xvf armv7l-linux-musleabihf-cross.tgz
RUN cd /opt/shared && cp -r armv7l-linux-musleabihf-cross/* /usr
RUN cd /opt/shared/ && rm -r armv7l-linux-musleabihf-cross*