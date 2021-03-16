#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

VMHOST=$1
VMHOST=${VMHOST^^}

# VMware virtualization
if [ $VMHOST == 'VMWARE' ]; then
  echo "${CYAN}>> Enable VMware guest tools${NC}"
  pacman -S --noconfirm open-vm-tools
  systemctl enable vmtoolsd
fi

if [ $VMHOST == 'VIRTUALBOX']; then
  echo "${CYAN}>> Enable VirtualBox guest tools${NC}"
  pacman -S --noconfirm virtualbox-guest-utils
  systemctl enable vboxservice
fi
