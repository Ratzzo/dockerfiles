FROM alpine:edge
#docker build . -t ratzzo/alpine-code-server

RUN apk add --no-cache llvm shadow sudo git icu-data-full \
yarn curl python3 bash jq \
npm make gcc g++ pkgconfig \
libxkbfile libxkbfile-dev sqlite \
sqlite-dev libsecret libsecret-dev \
rsync openssh

#sad, but we cannot use the latest node with code-server, see https://github.com/coder/code-server/issues/1633
RUN mkdir -p /opt/node_build; cd /opt/node_build; git clone --depth=1 --branch v16.20.0 https://github.com/nodejs/node.git
RUN cd /opt/node_build/node; ./configure && make -j20 && make install
#RUN ln -s /usr/bin/python3 /usr/bin/python
RUN yarn global add code-server@4.12.0
RUN touch /opt/containerized; echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
#RUN apk del --no-cache gcc g++
RUN rm -r /usr/local/share/.cache
ADD scripts /opt/scripts

CMD [ "/opt/scripts/setup.sh" ]


