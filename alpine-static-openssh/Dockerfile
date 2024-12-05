FROM alpine:edge
#docker build -t ratzzo/alpine-sdk .


#run the downloads in a separate layer
RUN \
apk fix; \
apk add --no-cache alpine-sdk sudo nano screen; \
adduser builder; echo -e "builder   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; \
chmod 777 /opt; \
cd /opt/ && sudo -u builder git clone --depth=1 git://git.alpinelinux.org/aports

RUN \
addgroup builder abuild; \
mkdir -p /var/cache/distfiles; \
chmod a+w /var/cache/distfiles; \
su builder -c 'echo -e "\n" | abuild-keygen -a'; \
apk add linux-headers perl openssl-libs-static zlib-static openssl-dev zlib-dev autoconf automake \
libedit-static libedit-dev linux-pam-dev krb5-dev libfido2-dev utmps-static utmps-dev openssh-client;

ADD scripts /opt/scripts
RUN chown -R builder:builder /opt/scripts/openssh; apk add openssh;  
RUN cd /opt/scripts/openssh; \
sudo -u builder BOOTSTRAP=1 abuild fetch; \
sudo -u builder BOOTSTRAP=1 abuild unpack; \
sudo -u builder BOOTSTRAP=1 abuild prepare; \
sudo -u builder BOOTSTRAP=1 abuild build; \
cp /opt/scripts/openssh/src/openssh-9.1p1/sshd /usr/sbin/sshd