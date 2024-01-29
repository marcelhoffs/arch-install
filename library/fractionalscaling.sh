#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo 'Please run with root privileges:'
  echo './fractionalscaling.sh'
else
  # Enable fractional scaling
  echo ''
  echo -e "${CYAN}"'>> Enable fractional scaling'"${NC}"
  
  # Create config: /etc/dconf/profile/user
  mkdir -p /etc/dconf/profile
  echo 'user-db:user' > /etc/dconf/profile/user
  echo 'system-db:local' >> /etc/dconf/profile/user
  
  # Create config: /etc/dconf/db/local.d/00-hidpi
  mkdir -p /etc/dconf/db/local.d
  echo '[org/gnome/mutter]' > /etc/dconf/db/local.d/00-hidpi
  echo 'experimental-features=['scale-monitor-framebuffer']' >> /etc/dconf/db/local.d/00-hidpi
  
  # Create config: /etc/dconf/db/locks/hidpi
  mkdir -p /etc/dconf/db/locks
  echo '/org/gnome/mutter/experimental-features' > /etc/dconf/db/locks/hidpi
  
  # Update dconf
  dconf update
fi