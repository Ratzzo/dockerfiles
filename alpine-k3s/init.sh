#!/bin/sh

#sht
SSHDIR=/tmp/shared
ALGO=rsa
BITS=2048
SSH_PORT="${SSH_PORT:=22}"

mkdir -p $SSHDIR
rm -f $SSHDIR/id_$ALGO
rm -f $SSHDIR/id_$ALGO.pub

sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config

chown $UPDATER_STUB_USER:$UPDATER_STUB_USER $SSHDIR
su $UPDATER_STUB_USER -c "ssh-keygen -t $ALGO -P '' -b $BITS -f $SSHDIR/id_$ALGO; mkdir -p ~/.ssh/; cp $SSHDIR/id_$ALGO.pub ~/.ssh/authorized_keys; cd ~ && chmod 700 -R .ssh"


service sshd start
#service nginx start

su $UPDATER_STUB_USER -c "cd ~ && sh"
