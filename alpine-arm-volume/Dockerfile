FROM arm32v7/alpine:latest

RUN apk add --no-cache sudo make shadow curl-dev luajit luajit-dev apr apr-dev sqlite-dev rapidjson rapidjson-dev
VOLUME /usr /lib /bin

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
