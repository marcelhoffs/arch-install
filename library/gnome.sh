#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install GNOME
echo ''
echo -e "${CYAN}"'>> Installing GNOME'"${NC}"
pacman -S --noconfirm gdm gnome gnome-tweak-tool gnome-bluetooth gnome-software-packagekit-plugin

# Enable services
systemctl enable gdm
