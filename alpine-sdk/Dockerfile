FROM alpine:edge
#docker build -t ratzzo/alpine-sdk .


#run the downloads in a separate layer
RUN \
apk fix; \
apk add --no-cache alpine-sdk sudo nano screen; \
adduser builder; echo -e "builder   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; \
cd /opt/ && git clone --depth=1 git://git.alpinelinux.org/aports

RUN \
addgroup builder abuild; \
chown -R builder:builder /opt/aports; \
mkdir -p /var/cache/distfiles; \
chmod a+w /var/cache/distfiles; \
su builder -c 'echo -e "\n" | abuild-keygen -a';
