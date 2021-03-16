#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

USERNAME=$1
USERNAME=${USERNAME,,}
PASSWORD=$2

if [ $# -eq 2 ]; then
  # Create a new user
  echo "${CYAN}>> Creating new user: $USERNAME${NC}"
  useradd -m -g users -s /bin/bash $USERNAME
  echo $USERNAME:$PASSWORD | chpasswd
  echo "$USERNAME ALL=(ALL) ALL" >>/etc/sudoers.d/$USERNAME

  # Create alias for ll
  echo '' >>/home/$USERNAME/.bashrc
  echo '# Custom aliasses' >>/home/$USERNAME/.bashrc
  echo 'alias ll='\''ls -l'\''' >>/home/$USERNAME/.bashrc

  # Modify .bash_profile
  echo '' >>/home/$USERNAME/.bash_profile
  echo '# Clear screen and run neofetch' >>/home/$USERNAME/.bash_profile
  echo 'clear' >>/home/$USERNAME/.bash_profile
  echo 'neofetch' >>/home/$USERNAME/.bash_profile
else
  echo "Provide a username and password."
  echo "Usage: createuser.sh <username> <password>"
fi
