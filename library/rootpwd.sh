#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

if [ $# -eq 1 ]; then
  # Set root password
  echo ''
  echo -e "${CYAN}"'>> Setting root password'"${NC}"
  echo root:"$1" | chpasswd -c SHA512
else
  echo 'Provide a password.'
  echo 'Usage: rootpwd.sh <password>'
fi
