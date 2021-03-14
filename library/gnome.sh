#!/bin/bash

# Install GNOME
echo ">> Installing GNOME"
pacman -S --noconfirm gdm gnome gnome-tweak-tool gnome-bluetooth chrome-gnome-shell gnome-software-packagekit-plugin

# Minimalize GNOME
pacman -Rsn --noconfirm gnome-books gnome-music gnome-maps gnome-contacts gnome-documents gnome-boxes gnome-calendar epiphany totem gnome-weather

# Enable services
systemctl enable gdm