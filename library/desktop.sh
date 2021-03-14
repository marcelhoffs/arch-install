#!/bin/bash

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
echo ' 1) Gnome'
echo ' 2) KDE'
echo ' 3) Mate'
echo ' 4) XFCE'
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
        # Install KDE
        ./library/kde.sh
      ;;
      3)
        # Install MATE
        ./library/mate.sh
      ;;
      4)
        # Install XFCE
        ./library/xfce.sh
      ;;
      *)
        echo "Wrong option"
      ;;
    esac
  
    # Install base applications
    ./library/baseapps.sh
    
    # Reboot 
    reboot
fi