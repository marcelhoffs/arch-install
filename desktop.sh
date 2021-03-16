#!/bin/bash

if [ "$EUID" -ne 0 ]
  then 
    # Not root
    echo "Please run as root privileges:"
    echo "sudo ./desktop.sh"
  else    
    # Clear screen
    clear
    echo '=============================================='
    echo ' Arch Linux Desktop Environment installation  '
    echo ' Marcel Hoffs, 14.03.2021                     '
    echo ' Version 1.0                                  '
    echo '=============================================='
    echo ''
    echo ' Available Desktop Environments:'
    echo ''
    echo ' 1) Gnome (default)'
    echo ' 2) Gnome (minimal)'
    echo ' 3) KDE'
    echo ' 4) Mate'
    echo ' 5) XFCE'
    echo ''
    echo ' q) Quit'
    echo ''
    # Ask some questions
    read -p ' Which one do you want to install?: ' INSTALL_DE
    
    INSTALL_DE=${INSTALL_DE^^}

    if [ $INSTALL_DE == 'Q' ]
      then
        echo ''
        echo '=============================================='
        echo ' Installation aborted.                        '
        echo '=============================================='
        echo ''
      else
        # Install X.org
        ./library/xorg.sh
      
        # Install graphics drivers
        ./library/gpu.sh
      
        # Install fonts
        ./library/fonts.sh
      
        case $INSTALL_DE in
          1)
            # Install GNOME
            ./library/gnome.sh
          ;;
          2)
            # Install GNOME
            ./library/gnome.sh MINIMAL
          ;;
          3)
            # Install KDE
            ./library/kde.sh
          ;;
          4)
            # Install MATE
            ./library/mate.sh
          ;;
          5)
            # Install XFCE
            ./library/xfce.sh
          ;;
          *)
            echo "Wrong option"
          ;;
        esac
      
        # Install base applications
        ./library/baseapps.sh

        # Update all
        pacman -Syu --noconfirm
        
        # Reboot 
        reboot
    fi
fi