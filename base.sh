#!/bin/bash

# Clear screen
echo '=============================================='
echo 'Arch Linux installation script                '
echo 'Marcel Hoffs, 14.03.2021                      '
echo 'Version 1.0                                   '
echo '=============================================='
echo ''

# Ask some questions
read -p 'Provide the desired hostname: ' INSTALL_HOSTNAME
read -p 'Do you want to install the LTS kernel [Y/N]: ' INSTALL_KERNEL_LTS
read -p 'Do you use an Intel or AMD CPU [INTEL/AMD]: ' INSTALL_CPU
read -p 'Create user: ' INSTALL_USER
read -p 'Set new user password: ' INSTALL_PASSWORD

# Make script executable
chmod +x library/*.sh

# Set hostname and hosts file
./library/hostname.sh $INSTALL_HOSTNAME

# Set timezone
./library/timezone.sh

# Install kernel
INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}
if [ $INSTALL_KERNEL_LTS == 'Y' ]
  then
    ./library/kernel.sh LTS
  else
    ./library/kernel.sh
fi

# Install base packages
#./library/basepackages.sh

# Install CPU Microcode
#./library/cpu.sh $INSTALL_CPU

# Update pacman mirror list
#./library/pacmanmirror.sh

# Set locale
#./library/locale.sh

# Enable services
#./library/services.sh

# Set root password

# Install bootloader

# Exit
echo '=============================================='
echo 'Finished installing Arch base installation.   '
echo 'Now unmount all   : umount -a                 '
echo 'Then reboot       : reboot                    '
echo '                                              '
echo 'After reboot login with:                      ' 
echo 'Username: ' $INSTALL_USER
echo 'Password: ' $INSTALL_PASSWORD
echo '=============================================='
exit