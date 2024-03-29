#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

USERNAME=$1
USERNAME=${USERNAME,,}

# Move the installation files
echo ''
echo -e "${CYAN}"'>> Moving installation files to user home ('"$USERNAME"')'"${NC}"
chmod -x ./base.sh
chmod +x ./gnomedesktop.sh
chown -R "$USERNAME": "$(pwd)"
mv "$(pwd)" /home/"$USERNAME"
