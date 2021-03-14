#!/bin/bash

# Install GNOME
echo ">> Installing GNOME"
pacman -S --noconfirm gdm gnome gnome-tweak-tool gnome-bluetooth chrome-gnome-shell
  
# Enable services
systemctl enable gdm