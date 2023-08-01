#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'
CURRENTUSER=$(whoami)

# Install extra packages
echo ''
echo -e "${CYAN}"'>> Installing extra packages'"${NC}"
pacman -S --noconfirm thunderbird gimp libreoffice-fresh libreoffice-fresh-nl bitwarden remmina gnome-boxes

# Remove electron application launcher icon
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/electron24.desktop