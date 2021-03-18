#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

KERNEL_LTS=$1
KERNEL_LTS=${KERNEL_LTS^^}

if [ $KERNEL_LTS == 'Y' ]; then
  # Install linux long term support kernel
  echo ''
  echo -e "${CYAN}>> Installing Linux Long Term Support (LTS) kernel${NC}"
  pacman -S --noconfirm linux-lts linux-lts-headers linux-firmware
fi

if [ $KERNEL_LTS == 'N' ]; then
  # Install linux default kernel
  echo ''
  echo -e "${CYAN}>> Installing Linux kernel${NC}"
  pacman -S --noconfirm linux linux-headers linux-firmware
fi
