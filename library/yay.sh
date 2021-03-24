#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install Yay
echo ''
echo -e "${CYAN}>> Install Yay package manager${NC}"
mkdir yay
cd yay || exit
git clone https://aur.archlinux.org/yay.git .
yes | makepkg -sic