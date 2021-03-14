#!/bin/bash

# Install KDE
echo ">> Installing KDE"
pacman -S --noconfirm plasma-meta plasma-wayland-session konsole dolphin avahi
  
# Enable services
systemctl enable sddm
systemctl enable avahi-daemon