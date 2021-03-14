#!/bin/bash

# Install base applications
echo ">> Installing base applications"
pacman -S --noconfirm --needed firefox samba git curl htop wget papirus-icon-theme flatpak cups

# Enable services
systemctl enable cups
systemctl enable samba