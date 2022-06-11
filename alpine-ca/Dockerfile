FROM ratzzo/alpine-sshd
ENV INHERIT_IMAGE_NAME=alpine-sshd
#docker build . -t ratzzo/alpine-CA

RUN mv /opt/scripts /opt/${INHERIT_IMAGE_NAME}-scripts/
ADD scripts /opt/scripts

ENTRYPOINT [ "/opt/scripts/entrypoint" ]
