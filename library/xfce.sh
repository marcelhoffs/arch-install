#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install XFCE
echo -e "${CYAN}>> Installing XFCE${NC}"
pacman -S --noconfirm lightdm lightdm-gtk-greeter xfce4 xfce4-goodies gnome-bluetooth

# Enable services
systemctl enable lightdm
