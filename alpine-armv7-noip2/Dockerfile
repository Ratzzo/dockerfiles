FROM arm32v7/alpine:edge

RUN apk --no-cache add gcc musl-dev
RUN	mkdir -p /opt/noip2/ && \
		cd /opt/noip2/ && \
		wget https://www.no-ip.com/client/linux/noip-duc-linux.tar.gz && \
		tar xvf noip-duc-linux.tar.gz && \
		cd noip-2.1.9-1 && \
		gcc -DPREFIX="" noip2.c -o noip2 && \
		cp noip2 /usr/bin

RUN apk --no-cache del gcc musl-dev