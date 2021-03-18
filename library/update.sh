#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Update
echo ''
echo -e "${CYAN}>> Update all upackages${NC}"
pacman -Syu --noconfirm