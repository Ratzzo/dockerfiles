FROM ratzzo/alpine-gcc
#docker build --squash

RUN apk add --no-cache automake gettext bison flex gperf intltool libtool lzip openssl xz p7zip gdk-pixbuf gawk python3 rsync gmp-dev musl-libintl mpc1 mpc1-dev mpfr-dev && mkdir -p /opt/shared
ADD scripts/build_arm_linux_gnueabihf.sh  /opt/build_arm_linux_gnueabihf.sh
RUN cd /opt/shared && ../build_arm_linux_gnueabihf.sh download
RUN cd /opt/shared && ../build_arm_linux_gnueabihf.sh build
RUN rm -r /opt/shared/; strip /usr/lib/gcc/arm-linux-gnueabihf/10.2.0/cc1 /usr/lib/gcc/arm-linux-gnueabihf/10.2.0/cc1plus


