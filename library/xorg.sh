#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install X.org packages
echo -e "${CYAN}>> Installing X.org packages${NC}"
pacman -S --noconfirm xorg-server xorg-xinit xorg-apps
