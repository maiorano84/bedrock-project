#!/bin/sh

eval `ssh-agent -s`
find ~/.ssh -type f -not -name "*.pub" -not -name "known_hosts" -not -name "authorized_keys" -not -name "config" -exec ssh-add {} \;

wordmove "$@"
