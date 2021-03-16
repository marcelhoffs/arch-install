#!/bin/bash

VMHOST=$1
VMHOST=${VMHOST^^}

# VMware virtualization
if [ $VMHOST == 'VMWARE' ]; then
  echo ">> Enable VMware guest tools"
  pacman -S --noconfirm open-vm-tools
  systemctl enable vmtoolsd
fi

if [ $VMHOST == 'VIRTUALBOX']; then
  echo ">> Enable VirtualBox guest tools"
  pacman -S --noconfirm virtualbox-guest-utils
  systemctl enable vboxservice
fi
