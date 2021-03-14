#!/bin/bash
if [ $# -eq 2 ]
  then
    # Create a new user
    echo ">> Set new user: $1"
    useradd -m -g users -s /bin/bash $1
    echo $1:$2 | chpasswd
    echo "$1 ALL=(ALL) ALL" >> /etc/sudoers.d/$1

    # Create alias for ll
    echo '' >> /home/$1/.bashrc
    echo '# Custo; aliasses' >> /home/$1/.bashrc
    echo 'alias ll='\''ls -l'\''' >> /home/$1/.bashrc

    # Modify .bash_profile
    echo '' >> /home/$1/.bash_profile
    echo '# Clear screen and run neofetch' >> /home/$1/.bash_profile
    echo 'clear' >> /home/$1/.bash_profile
    echo 'neofetch' >> /home/$1/.bash_profile
  else
    echo "Provide a username and password."
    echo "Usage: createuser.sh <username> <password>"
fi