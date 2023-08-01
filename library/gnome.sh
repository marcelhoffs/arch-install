#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'
CURRENTUSER=$(whoami)

# Install GNOME
echo ''
echo -e "${CYAN}"'>> Installing GNOME'"${NC}"
pacman -S --noconfirm gdm gnome gnome-tweak-tool gnome-bluetooth gst-plugin-pipewire wireplumber power-profiles-daemon gnome-firmware networkmanager-openconnect networkmanager-openvpn

# Remove applications
pacman -R --noconfirm epiphany gnome-music gnome-calendar gnome-photos

# Remove launcher icons
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/lstopo.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/qv4l2.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/qvidcap.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/stoken-gui.desktop
echo 'NoDisplay=true' > /home/"$CURRENTUSER"/.local/share/applications/stoken-gui-small.desktop

# Enable services
systemctl enable gdm
