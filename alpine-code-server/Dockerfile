FROM alpine:3.16
#docker build . -t ratzzo/alpine-code-server

RUN apk add --no-cache nodejs git icu-data-full nodejs yarn curl python3 bash jq npm make gcc g++ pkgconfig libxkbfile libxkbfile-dev sqlite sqlite-dev libsecret libsecret-dev
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN yarn global add code-server@4.4.0
RUN touch /opt/containerized && apk del --no-cache gcc g++ && apk add --no-cache sudo && rm -r /usr/local/share/.cache
ADD scripts /opt/scripts

CMD [ "/opt/scripts/setup.sh" ]


