#!/bin/bash

USERNAME=$1
USERNAME=${USERNAME,,}

# Move the installation files
echo ">> Moving installation files to user home ($USERNAME)"
chmod -x ./base.sh
chmod +x ./gnome.sh
chmod +x ./kde.sh
mv $(pwd) /home/$USERNAME
