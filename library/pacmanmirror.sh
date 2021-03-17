#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Update pacman mirrorlist
echo ''
echo -e "${CYAN}>> Select fastest pacman mirror${NC}"
reflector --country Belgium --country Netherlands --country Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
