#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

USERNAME=$1
USERNAME=${USERNAME,,}
PASSWORD=$2

if [ $# -eq 2 ]; then
  # Create a new user
  echo ''
  echo -e "${CYAN}"'>> Creating new user: '"$USERNAME""${NC}"
  useradd -m -g users -s /bin/bash "$USERNAME"
  usermod -aG adm "$USERNAME"
  usermod -aG wheel "$USERNAME"
  usermod -aG video "$USERNAME"
  echo "$USERNAME":"$PASSWORD" | chpasswd -c SHA512
  echo "$USERNAME"' ALL=(ALL) ALL' >>/etc/sudoers.d/"$USERNAME"

  # Create aliasses
  echo '' >>/home/"$USERNAME"/.bashrc
  echo '# Custom aliasses' >>/home/"$USERNAME"/.bashrc
  echo 'alias ll='\''ls -l'\''' >>/home/"$USERNAME"/.bashrc
  echo 'alias ip='\''ip -color=auto'\''' >>/home/"$USERNAME"/.bashrc

  # Modify .bash_profile
  echo '' >>/home/"$USERNAME"/.bash_profile
  echo 'export MOZ_ENABLE_WAYLAND=1' >>/home/"$USERNAME"/.bash_profile
else
  echo 'Provide a username and password.'
  echo 'Usage: createuser.sh <username> <password>'
fi
