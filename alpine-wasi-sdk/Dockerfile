FROM alpine:latest
#docker build --squash -t registry.ratzzo.net/ratzzo/alpine-wasi-sdk .

ENV THREADS=20
RUN echo -e "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && apk add --no-cache make llvm cmake clang python3 ninja binutils curl gcc musl-dev g++ bash perl git openssh

RUN cd /opt && \
    git clone --branch=main --depth=1 https://Ratzzo@bitbucket.org/Ratzzo/wasi-sdk.git

RUN cd /opt/wasi-sdk && \
    git submodule init && git submodule update
    
RUN cd /opt/wasi-sdk && git pull origin main && cp /opt/wasi-sdk/expected/wasm32-wasi/predefined-macros.txt /opt/wasi-sdk/src/wasi-libc/expected/wasm32-wasi/predefined-macros.txt

RUN cd /opt/wasi-sdk/ && make NINJA_FLAGS="-j ${THREADS}" package

#strip down container and leave only the sdk
RUN apk del llvm cmake clang python3 ninja curl gcc musl-dev g++ bash perl git openssh
RUN mv /opt/wasi-sdk/build/wasi-sdk* /opt && rm -r /opt/wasi-sdk

RUN apk add screen nodejs file

ADD scripts /opt/scripts

ENTRYPOINT [ "/opt/scripts/fix_uid_gid.sh" ]

