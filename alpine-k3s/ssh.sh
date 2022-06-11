#!/bin/sh

ssh -i $PWD/shared/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no updater-stub-user@127.0.0.1