#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

if [ $# -eq 1 ]; then
  HOSTNAME=$1
  HOSTNAME=${HOSTNAME,,}

  # Create hostname (/etc/hostname)
  echo ''
  echo -e "${CYAN}>> Setting hostname to: "$HOSTNAME${NC}
  echo $HOSTNAME >/etc/hostname

  # Create hosts file (/etc/hosts)
  echo ''
  echo -e "${CYAN}>> Creating hosts file${NC}"
  echo '# Static table lookup for hostnames.' >/etc/hosts
  echo '# See hosts(5) for details.' >>/etc/hosts
  echo '127.0.0.1 localhost' >>/etc/hosts
  echo '::1 localhost' >>/etc/hosts
  echo '127.0.1.1 '$HOSTNAME'.localdomain '$HOSTNAME >>/etc/hosts
else
  echo "Provide a hostname."
  echo "Usage: hostname.sh <hostname>"
fi
