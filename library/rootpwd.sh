#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

if [ $# -eq 1 ]; then
  # Set root password
  echo "${CYAN}>> Setting root password${NC}"
  echo root:$1 | chpasswd
else
  echo "Provide a password."
  echo "Usage: rootpwd.sh <password>"
fi
