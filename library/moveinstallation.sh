#!/bin/bash

USERNAME=$1
USERNAME=${USERNAME,,}

# Move the installation files
echo ">> Moving installation files to user home ($USERNAME)"
chmod -x ./base.sh
chmod +x ./desktop.sh
chown -R $USERNAME: $(pwd)
mv $(pwd) /home/$USERNAME
