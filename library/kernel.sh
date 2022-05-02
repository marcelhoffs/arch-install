#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install linux default kernel
echo ''
echo -e "${CYAN}"'>> Installing Linux kernel'"${NC}"
pacman -S --noconfirm linux linux-headers linux-firmware