#!/bin/bash

# Clear screen
clear
echo '=============================================='
echo ' Arch Linux installation script               '
echo ' Marcel Hoffs, 14.03.2021                     '
echo ' Version 1.0                                  '
echo '=============================================='
echo ''

# Ask some questions
read -p ' Provide the desired hostname: ' INSTALL_HOSTNAME
read -p ' Do you want to install the LTS kernel [Y/N]: ' INSTALL_KERNEL_LTS
read -p ' Do you use an Intel or AMD CPU [INTEL/AMD]: ' INSTALL_CPU
read -p ' Are you installing on a virtual host [VMWARE/VIRTUALBOX]: ' INSTALL_VIRTHOST
read -p ' Create new user: ' INSTALL_USER
read -p ' Set new user password: ' INSTALL_PASSWORD
echo ''
read -p ' Are you sure you want to continue? [Y/N]: ' INSTALL_CONTINUE

INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
if [ $INSTALL_CONTINUE == 'Y' ]
  then
    # Set hostname and hosts file
    ./hostname.sh $INSTALL_HOSTNAME
    
    # Set timezone
    ./timezone.sh
    
    # Install kernel
    INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}
    if [ $INSTALL_KERNEL_LTS == 'Y' ]
      then
        ./kernel.sh LTS
      else
        ./kernel.sh
    fi
    
    # Install base packages
    ./basepackages.sh
    
    # Install CPU Microcode
    ./cpu.sh $INSTALL_CPU
    
    # Update pacman mirror list
    ./pacmanmirror.sh
    
    # Set locale
    ./locale.sh
    
    # Install bootloader
    ./bootloader.sh

    # Install virtualization
    ./virtualization.sh $INSTALL_VIRTHOST
    
    # Enable services
    ./services.sh
    
    # Create user
    ./createuser.sh $INSTALL_USER $INSTALL_PASSWORD

    # Move installation files
    ./moveinstallation.sh $INSTALL_USER
    
    # Exit
    echo '=============================================='
    echo ' Finished installing Arch base installation.  '
    echo ' Exit chroot : exit                           '
    echo ' Unmount all : umount -a                      '
    echo ' Then reboot : reboot                         '
    echo '                                              '
    echo ' After reboot login with:                     ' 
    echo ' Username : '$INSTALL_USER
    echo ' Password : '$INSTALL_PASSWORD
    echo '=============================================='
  else
    echo ''
    echo '=============================================='
    echo ' Installation aborted.                        '
    echo '=============================================='
    echo ''
fi