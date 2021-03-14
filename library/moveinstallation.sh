#!/bin/bash

USERNAME=$1
USERNAME=${USERNAME,,}

# Move the installation files
echo ">> Moving installation files to user home ($USERNAME)"
chmod -x ./install_base.sh
chmod +x ./install_desktop.sh
chown -R $USERNAME: $(pwd)
mv $(pwd) /home/$USERNAME