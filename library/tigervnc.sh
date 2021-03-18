#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install TigerVNC
echo ''
echo -e "${CYAN}>> Install TigerVNC package manager${NC}"
sudo pacman -S --noconfirm tigervnc

# Set VNC password
echo ''
echo -e "${CYAN}>> Provide VNC password${NC}"
vncpasswd

# Set user
sudo echo ':1='"$USER" >> /etc/tigervnc/vncserver.users

# Create config files
echo 'session=gnome' > ~/.vnc/config
echo 'geometry=1920x1080' >> ~/.vnc/config
echo 'alwaysshared' >> ~/.vnc/config

# Enable the service
sudo systemctl enable vncserver@:1 --now