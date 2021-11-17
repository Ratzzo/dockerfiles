#!/bin/sh

docker run -v $PWD/shared:/tmp/shared --env SSH_PORT --network host --rm -it ratzzo/alpine-updater-git-stub