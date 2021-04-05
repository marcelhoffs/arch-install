#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Enable services
echo ''
echo -e "${CYAN}"'>> Enable services'"${NC}"
systemctl enable sshd
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable fstrim.timer
systemctl enable tlp