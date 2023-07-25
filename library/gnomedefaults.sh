#!/bin/bash
CURRENTUSER=$(whoami)

# Copy wallpaper
mkdir -p /home/"$CURRENTUSER"/Pictures
cp ../wallpapers/* /home/"$CURRENTUSER"/Pictures

# Set wallpaper
gsettings set org.gnome.desktop.background picture-uri file:///home/"$CURRENTUSER"/Pictures/vanilla-default.png
gsettings set org.gnome.desktop.background picture-uri-dark file:///home/"$CURRENTUSER"/Pictures/vanilla-dark.png

# Center new windows
gsettings set org.gnome.mutter center-new-windows true

# Enable Geolocation
gsettings set org.gnome.system.location enabled true

# Time settings
gsettings set org.gnome.desktop.interface clock-format "24h" 
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.datetime automatic-timezone true

# Icons
gsettings set org.gnome.desktop.interface icon-theme "Papirus"

# Touchpad
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
