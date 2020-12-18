#!/bin/sh

eval `ssh-agent -s`

if [ ! -d "~/.ssh" ]; then
  mkdir -p ~/.ssh
fi

cp -r /wordmove/.ssh/* ~/.ssh
find ~/.ssh -type f -not -name "*.pub" -not -name "known_hosts" -not -name "authorized_keys" -not -name "config" -follow -print | while read -r f; do
  chmod 600 $f
  ssh-add $f
done

wordmove "$@"
