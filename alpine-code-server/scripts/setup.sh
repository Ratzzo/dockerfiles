#!/bin/bash 

if [ ! -f /opt/containerized ]; then echo "Should run inside the container."; exit 1; fi;

_USER=${_USER:-root}
_UID=${_UID:-$(id -u)}
_GID=${_GID:-$(id -g)}

if [ "$_UID" != "0" ]
then
    _USER=container
    addgroup -g 10000 tempgroup 2> /dev/null
    adduser -D -u $_UID -G tempgroup $_USER 2> /dev/null
    RET=$?
    _CREATEDUSER=$(getent passwd $_UID | cut -d: -f1)
    if [ "$RET" == "1" ]
    then
        echo "WARNING: Deleting user $_CREATEDUSER"
        deluser $_CREATEDUSER
        DELETED_USER=1
    fi
    
    addgroup -g $_GID $_USER
    RET=$?
    _CREATEDGROUP=$(getent group $_GID | cut -d: -f1)
    if [ "$RET" == "1" ]
    then
        echo "WARNING: Deleting group $_CREATEDGROUP";
        delgroup $_USER
        addgroup -g $_GID $_USER
    fi
    
    if [ "$DELETED_USER" == "1" ]
    then
        echo "Adding user $_USER"
        adduser -D -u $_UID -G $_USER $_USER
    fi
    
    echo "${_USER} ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    
fi

mkdir -p /tmp/shared
if [ -f /tmp/shared/code-server.yaml ]; then chmod 666 /tmp/shared/code-server.yaml; fi;
sudo -H -u $_USER "$@"
