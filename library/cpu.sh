#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

CPU=$1
CPU=${CPU^^}

# Install CPU specific microcode
if [ "$CPU" == 'INTEL' ]; then
  echo ''
  echo -e "${CYAN}"'>> Installing Intel packages'"${NC}"
  pacman -S --noconfirm intel-ucode iucode-tool
fi

if [ "$CPU" == 'AMD' ]; then
  echo ''
  echo -e "${CYAN}"'>> Installing AMD packages'"${NC}"
  pacman -S --noconfirm amd-ucode
fi
