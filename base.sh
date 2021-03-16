#!/bin/bash

if [ "$EUID" -ne 0 ]
  then 
    # Not root
    echo "Please run as root privileges:"
    echo "sudo ./install_desktop.sh"
  else
    # Clear screen
    clear
    echo '=============================================='
    echo ' Arch Linux installation script               '
    echo ' Marcel Hoffs, 14.03.2021                     '
    echo ' Version 1.0                                  '
    echo '=============================================='
    echo ''
    
    # Ask some questions
    # What type of install
    while [ "$INSTALL_UEFI" != "BIOS" ] && [ "$INSTALL_UEFI" != "UEFI" ]
      do
        read -p ' Install on BIOS or UEFI [BIOS/UEFI]: ' INSTALL_UEFI
        INSTALL_UEFI=${INSTALL_UEFI^^}
    done
    
    if [ $INSTALL_UEFI == 'BIOS' ]
      then
        read -p ' On which device are you installing [e.g. /dev/sda]: ' INSTALL_DEVICE
    fi
    read -p ' Provide the desired hostname: ' INSTALL_HOSTNAME
    read -p ' Do you want to install the LTS kernel [Y/N]: ' INSTALL_KERNEL_LTS
    read -p ' Do you use an Intel or AMD CPU [INTEL/AMD]: ' INSTALL_CPU
    read -p ' Are you installing on a virtual host [VMWARE/VIRTUALBOX]: ' INSTALL_VIRTHOST
    read -p ' Set root password: ' INSTALL_ROOT_PWD
    read -p ' Create new user: ' INSTALL_USER
    read -p ' Set new user password: ' INSTALL_PASSWORD
    echo ''
    read -p ' Are you sure you want to continue? [Y/N]: ' INSTALL_CONTINUE
    
    INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
    if [ $INSTALL_CONTINUE == 'Y' ]
      then
        # Make scripts executable
        chmod +x ./library/*.sh
        
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
        ./library/basepackages.sh
        
        # Install CPU Microcode
        ./library/cpu.sh $INSTALL_CPU
        
        # Update pacman mirror list
        ./library/pacmanmirror.sh
        
        # Set locale
        ./library/locale.sh
        
        # Install bootloader
        ./library/bootloader.sh $INSTALL_UEFI $INSTALL_DEVICE
    
        # Install virtualization
        ./library/virtualization.sh $INSTALL_VIRTHOST
        
        # Enable services
        ./library/services.sh
    
        # Set root password
        ./library/rootpwd.sh $INSTALL_ROOT_PWD
        
        # Create user
        ./library/createuser.sh $INSTALL_USER $INSTALL_PASSWORD
    
        # Move installation files
        ./library/moveinstallation.sh $INSTALL_USER
        
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
fi