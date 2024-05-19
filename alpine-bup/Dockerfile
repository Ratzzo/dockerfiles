FROM alpine:edge

RUN	apk add --no-cache python3 git py3-tornado gcc make musl-dev linux-headers bash python3-dev
RUN cd /opt; git clone --branch 0.33.3 https://github.com/bup/bup; cd /opt/bup; make && make install
RUN apk del gcc make musl-dev linux-headers python3-dev
