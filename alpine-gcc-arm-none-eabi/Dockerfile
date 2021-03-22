FROM alpine:edge
#docker build -t ratzzo/alpine-gcc-arm-none-eabi .
#docker run --privileged -v $PWD/opt:/opt -v /dev/bus/usb:/dev/bus/usb --rm -it ratzzo/alpine-gcc-arm-none-eabi:latest

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories 
RUN apk add --no-cache build-base git gcc-arm-none-eabi newlib-arm-none-eabi flashrom python2 stlink

#git clone https://github.com/dword1511/stm32-vserprog.git
#git submodule update --init --recursive
#make BOARD=stm32-vserprog-v3
#make flash-stlink