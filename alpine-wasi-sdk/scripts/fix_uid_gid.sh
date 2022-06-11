#!/bin/sh

addgroup -g $GID user
adduser -D -u $UID -G user user
su user
sh
exit
