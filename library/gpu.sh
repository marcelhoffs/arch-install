#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

GPU=$1
GPU=${GPU^^}

# Install Intel specific packages
if [ "$GPU" == 'INTEL' ]; then
  echo ''
  echo -e "${CYAN}"'>> Installing Intel graphics drivers'"${NC}"
  pacman -S --noconfirm xf86-video-vesa mesa vulkan-intel
fi

# Install AMD specific packages
if [ "$CPU" == 'AMD' ]; then
  echo ''
  echo -e "${CYAN}"'>> Installing AMD graphics drivers'"${NC}"
  pacman -S --noconfirm xf86-video-vesa xf86-video-amdgpu mesa vulkan-radeon
fi

# Install Nvidia specific packages
if [ "$CPU" == 'NVIDIA' ]; then
  echo ''
  echo -e "${CYAN}"'>> Installing Nvidia graphics drivers'"${NC}"
  pacman -S --noconfirm xf86-video-vesa nvidia
fi