#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Run as regular user, not as root
if [ "$EUID" -ne 0 ]; then
  # Get current user
  CURRENT_USER=$USER

  # Install TigerVNC
  echo ''
  echo -e "${CYAN}>> Install TigerVNC package manager${NC}"
  sudo pacman -S --noconfirm tigervnc
  
  # Set VNC password
  echo ''
  echo -e "${CYAN}>> Provide VNC password${NC}"
  vncpasswd
  
  # Setting configuration
  echo ''
  echo -e "${CYAN}>> Configuring VNC server${NC}"
  # Set user
  echo ':1='"$CURRENT_USER" | sudo tee -a /etc/tigervnc/vncserver.users
  
  # Create config files
  echo 'session=gnome' > ~/.vnc/config
  echo 'geometry=1920x1080' >> ~/.vnc/config
  echo 'alwaysshared' >> ~/.vnc/config
  
  # Enable the service
  echo ''
  echo -e "${CYAN}>> Enabling VNC server${NC}"
  sudo systemctl enable vncserver@:1 --now 
else
  # Root
  echo "Do not execute this script with root privileges"
fi