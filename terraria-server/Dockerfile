FROM debian:buster-slim

ENV TERRARIA_VERSION=1434

RUN apt-get -y update && apt-get -y install wget unzip && cd /opt && \
    wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-$TERRARIA_VERSION.zip && \
    cd /opt && \
    unzip terraria-server-$TERRARIA_VERSION.zip && \
    rm terraria-server-$TERRARIA_VERSION.zip && \
    rm -r $TERRARIA_VERSION/Windows $TERRARIA_VERSION/Mac && \
    chmod +x $TERRARIA_VERSION/Linux/TerrariaServer.bin.x86_64

ADD scripts /opt/scripts
