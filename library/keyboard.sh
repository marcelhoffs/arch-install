#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

KEYBOARD=$1
KEYBOARD=${KEYBOARD,,}

# Set keyboard
echo ''
echo -e "${CYAN}"'>> Set keyboard'"${NC}"
echo 'KEYMAP='"$KEYBOARD" >/etc/vconsole.conf
