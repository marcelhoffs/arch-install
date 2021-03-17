#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

KERNEL=$1
KERNEL=${KERNEL^^}

if [ $KERNEL == 'LTS' ]; then
  # Install linux long term support kernel
  echo ''
  echo -e "${CYAN}>> Installing Linux Long Term Support (LTS) kernel${NC}"
  pacman -S --noconfirm linux-lts linux-lts-headers linux-firmware
else
  # Install linux long term support kernel
  echo ''
  echo -e "${CYAN}>> Installing Linux kernel${NC}"
  pacman -S --noconfirm linux linux-headers linux-firmware
fi
