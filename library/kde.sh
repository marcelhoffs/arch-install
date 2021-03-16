#!/bin/bash

# Install KDE
echo ">> Installing KDE"
pacman -S --noconfirm plasma-meta plasma-wayland-session konsole dolphin

# Enable services
systemctl enable sddm
