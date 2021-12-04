#!/bin/sh

mkdir -p $PWD/shared
docker run --privileged -v $PWD/shared:/tmp/shared -v $PWD/scripts:/opt/scripts -p 0.0.0.0:5100:5100 --rm -it ratzzo/registry
