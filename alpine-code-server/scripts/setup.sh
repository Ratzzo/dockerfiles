#!/bin/bash 

if [ ! -f /opt/containerized ]; then echo "Should run inside the container."; exit 1; fi;

_USER=${_USER:-root}
_UID=${_UID:-$(id -u)}
_GID=${_GID:-$(id -g)}

echo $_USER $_UID $_GID
if [ "$_UID" != "0" ]
then
    addgroup -g $_GID $_USER
    adduser -D -u $_UID -G $_USER $_USER
    echo "${_USER} ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

mkdir -p /tmp/shared
if [ -f /tmp/shared/code-server.yaml ]; then chmod 666 /tmp/shared/code-server.yaml; fi;
sudo -H -u $_USER "$@"
