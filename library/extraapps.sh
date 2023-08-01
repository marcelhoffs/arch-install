#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install extra packages
echo ''
echo -e "${CYAN}"'>> Installing extra packages'"${NC}"
pacman -S --noconfirm thunderbird gimp libreoffice-fresh libreoffice-fresh-nl bitwarden remmina gnome-boxes

# Remove electron application launcher icon
echo 'NoDisplay=true' > ~/.local/share/applications/electron24.desktop