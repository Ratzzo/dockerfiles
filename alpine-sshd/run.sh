#!/bin/sh

mkdir -p $PWD/shared
docker run --privileged -v $PWD/shared:/tmp/shared -v $PWD/scripts:/opt/scripts --env SSH_PORT --network host --rm -it ratzzo/alpine-sshd
