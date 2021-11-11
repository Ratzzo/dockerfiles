FROM alpine:edge
#docker build -t ratzzo/alpine-gcc .

RUN apk add --no-cache build-base xvfb git openssh curl-dev curl autoconf xorg-server-dev libjpeg mandoc rsync

#build custom fltk
RUN cd /opt && git clone --depth=1 https://Ratzzo@bitbucket.org/Ratzzo/fltk.git
RUN cd /opt/fltk && ./autogen.sh && ./configure --prefix=/usr && make -j4 && make install
RUN apk add --no-cache rapidjson-dev leptonica leptonica-dev apr apr-dev fontconfig fontconfig-dev \
	libxrender libxrender-dev libxcursor libxcursor-dev libxft libxft-dev libxinerama libxinerama-dev jpeg jpeg-dev
