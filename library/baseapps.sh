#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install base applications
echo ''
echo -e "${CYAN}"'>> Installing base applications'"${NC}"
pacman -S --noconfirm --needed firefox git curl htop wget papirus-icon-theme flatpak cups avahi zip unzip unrar

# Enable services
systemctl enable cups
systemctl enable avahi-daemon
