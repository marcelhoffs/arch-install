#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

VMHOST=$1
VMHOST=${VMHOST^^}

# VMware virtualization
if [ $VMHOST == 'VMWARE' ]; then
  echo ''
  echo -e "${CYAN}>> Enable VMware guest tools${NC}"
  pacman -S --noconfirm open-vm-tools xf86-video-vmware
  systemctl enable vmtoolsd
fi

if [ $VMHOST == 'VIRTUALBOX']; then
  echo ''
  echo -e "${CYAN}>> Enable VirtualBox guest tools${NC}"
  pacman -S --noconfirm virtualbox-guest-utils xf86-video-vmware
  systemctl enable vboxservice
fi
