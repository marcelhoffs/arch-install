#!/bin/bash

MINIMAL=$1
MINIMAL=${MINIMAL^^}

# Install GNOME
echo ">> Installing GNOME"
pacman -S --noconfirm gdm gnome gnome-tweak-tool gnome-bluetooth chrome-gnome-shell gnome-software-packagekit-plugin

if [ $MINIMAL == 'MINIMAL' ]
  then 
    # Minimalize GNOME
    pacman -Rsn --noconfirm gnome-books gnome-music gnome-maps gnome-contacts gnome-documents gnome-boxes gnome-calendar epiphany totem gnome-weather gnome-photos
fi 

# Enable services
systemctl enable gdm