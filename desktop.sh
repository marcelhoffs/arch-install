#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo "Please run as root privileges:"
  echo "sudo ./desktop.sh"
else
  # Ask what desktop to install
  while [[ ! $INSTALL_DE =~ ^(1|2|3|4|5|Q)$ ]]; do
    clear
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${CYAN} Arch Linux Desktop Environment installation  ${NC}"
    echo -e "${CYAN} Marcel Hoffs, 14.03.2021                     ${NC}"
    echo -e "${CYAN} Version 1.0                                  ${NC}"
    echo -e "${CYAN}==============================================${NC}"
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

    read -p ' Which one do you want to install: ' INSTALL_DE
    INSTALL_DE=${INSTALL_DE^^}
  done

  # Continue if not aborted
  if [ $INSTALL_DE == 'Q' ]; then
    echo ''
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${CYAN} Installation aborted.                        ${NC}"
    echo -e "${CYAN}==============================================${NC}"
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
