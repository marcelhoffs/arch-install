#!/bin/bash

if [ $# -eq 2 ]
  then
    # Create a new user
    echo ">> Set new user: $1"
    useradd -m -g users -s /bin/bash $1
    echo $1:$2 | chpasswd
    echo "$1 ALL=(ALL) ALL" >> /etc/sudoers.d/$1
  else
    echo "Provide a username and password."
    echo "Usage: createuser.sh <username> <password>"
fi