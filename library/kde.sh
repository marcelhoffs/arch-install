#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install KDE
echo -e "${CYAN}>> Installing KDE${NC}"
pacman -S --noconfirm plasma-meta plasma-wayland-session konsole dolphin

# Enable services
systemctl enable sddm
