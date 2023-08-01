#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'
CURRENTUSER=$(whoami)

# Setting GNOME defaults
echo ''
echo -e "${CYAN}"'>> Setting GNOME defaults'"${NC}"

# Set avatar
busctl call org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u "$CURRENTUSER") org.freedesktop.Accounts.User SetIconFile s /usr/share/pixmaps/faces/hummingbird.jpg

# Copy wallpaper
mkdir -p /home/"$CURRENTUSER"/Pictures
cp wallpapers/* /home/"$CURRENTUSER"/Pictures

# Set wallpaper
gsettings set org.gnome.desktop.background picture-uri file:///home/"$CURRENTUSER"/Pictures/vanilla-default.png
gsettings set org.gnome.desktop.background picture-uri-dark file:///home/"$CURRENTUSER"/Pictures/vanilla-dark.png

# Favorite apps
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Console.desktop', 'org.gnome.Software.desktop']"

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

# Fonts
gsettings set org.gnome.desktop.interface font-name "Noto Sans 12"
gsettings set org.gnome.desktop.interface document-font-name "Noto Sans 12"
gsettings set org.gnome.desktop.interface monospace-font-name "Source Code Pro 14"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Noto Sans Bold 12"

# Battery inidicator
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Touchpad
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true

# Remove launcher icons
mkdir -p /home/"$CURRENTUSER"/.local/share/applications
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/lstopo.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/qv4l2.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/qvidcap.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/stoken-gui.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/stoken-gui-small.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/electron24.desktop