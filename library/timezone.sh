#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Set timezone
echo ''
echo -e "${CYAN}"'>> Setting timezone to: Europe/Brussels'"${NC}"
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc
