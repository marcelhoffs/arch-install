#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install graphics drivers
echo -e "${CYAN}>> Installing graphics drivers${NC}"
pacman -S --noconfirm mesa xf86-video-vesa xf86-video-vmware xf86-video-fbdev vulkan-intel
