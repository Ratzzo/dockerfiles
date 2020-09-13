#!/bin/sh

groupadd -g $ASGID user
useradd -u $ASUID -g $ASGID user
echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
su user
sh