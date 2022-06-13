#!/bin/sh

_USER=ratzzo \
_UID=$(id -u $_USER) \
_GID=$(id -g $_USER) \
docker run --rm \
    --network host \
    -e _USER \
    -e _UID \
    -e _GID \
    -v $PWD/scripts:/opt/scripts \
    -v $PWD/shared:/tmp/shared \
    -it ratzzo/alpine-code-server /opt/scripts/setup.sh sh
    
#code-server --socket /tmp/shared/code-server.sock --socket-mode 777 --config /tmp/shared/code-server.yaml /tmp/shared
