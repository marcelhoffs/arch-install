#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install base applications
echo -e "${CYAN}>> Installing base applications${NC}"
pacman -S --noconfirm --needed firefox samba git curl htop wget papirus-icon-theme flatpak cups avahi

# Enable services
systemctl enable cups
systemctl enable samba
systemctl enable avahi-daemon
