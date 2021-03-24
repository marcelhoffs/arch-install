#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install MATE
echo ''
echo -e "${CYAN}"'>> Installing MATE'"${NC}"
pacman -S --noconfirm lightdm lightdm-gtk-greeter mate mate-extra network-manager-applet blueman mate-power-manager adapta-gtk-theme arc-gtk-theme

# Enable services
systemctl enable lightdm
