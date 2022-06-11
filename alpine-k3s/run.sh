#!/bin/sh

mkdir -p $PWD/shared
docker run --privileged -v $PWD/shared:/tmp/shared --env SSH_PORT --network host --rm -it ratzzo/alpine-k3s
