#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install fonts
echo ''
echo -e "${CYAN}"'>> Installing fonts'"${NC}"
pacman -S --noconfirm ttf-roboto ttf-fira-sans ttf-fira-mono ttf-fira-code noto-fonts
