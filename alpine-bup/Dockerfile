FROM alpine:edge

RUN	apk add --no-cache python3 git py3-tornado gcc make musl-dev linux-headers bash python3-dev rsync openssh py3-pip py3-pytest par2cmdline 
RUN python -m pip install --break-system-packages pyxattr
RUN cd /opt; git clone --branch 0.33.3 https://github.com/bup/bup; cd /opt/bup; make && make install
RUN apk del gcc make musl-dev linux-headers python3-dev py3-pytest
