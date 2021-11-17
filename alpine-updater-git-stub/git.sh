#!/bin/sh

#for reference only
ABS_SCRIPT_PATH=$(cd $(dirname $0) && echo $PWD)
export GIT_SSH_COMMAND="ssh -i $ABS_SCRIPT_PATH/shared/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
rm -rf repo1_dest
git clone ssh://updater-stub-user@127.0.0.1:/tmp/shared/repo1 repo1_dest