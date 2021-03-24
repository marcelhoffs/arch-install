#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install Pamac
echo ''
echo -e "${CYAN}>> Install Pamac package manager${NC}"
mkdir pamac
cd pamac || exit
git clone https://aur.archlinux.org/pamac-aur.git .
yes | makepkg -sic