#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

MINIMAL=$1
MINIMAL=${MINIMAL^^}

# Install GNOME
echo ''
echo -e "${CYAN}"'>> Installing GNOME'"${NC}"
pacman -S --noconfirm gdm gnome gnome-tweak-tool gnome-bluetooth chrome-gnome-shell gnome-software-packagekit-plugin

if [ "$MINIMAL" == 'MINIMAL' ]; then
  # Minimalize GNOME
  pacman -Rsn --noconfirm gnome-books gnome-music gnome-maps gnome-contacts gnome-documents gnome-boxes gnome-calendar epiphany totem gnome-weather gnome-photos
  pacman -Qtdq | pacman -Rns -
fi

# Enable services
systemctl enable gdm
