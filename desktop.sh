#!/bin/bash
CYAN='\e[1;36m'
WHITE='\e[1;37m'
NC='\e[0m'
INSTALL_LOG='install_desktop.log'

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo "Please run as root privileges:"
  echo "sudo ./desktop.sh"
else
  # Ask what desktop to install
  while [[ ! $INSTALL_DE =~ ^(1|2|3|4|5|Q)$ ]]; do
    clear
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${WHITE} Arch Linux Desktop Environment installation ${NC}"
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
    ./library/xorg.sh | tee $INSTALL_LOG

    # Install graphics drivers
    ./library/gpu.sh | tee $INSTALL_LOG

    # Install fonts
    ./library/fonts.sh | tee $INSTALL_LOG

    case $INSTALL_DE in
    1)
      # Install GNOME
      ./library/gnome.sh | tee $INSTALL_LOG
      ;;
    2)
      # Install GNOME
      ./library/gnome.sh MINIMAL | tee $INSTALL_LOG
      ;;
    3)
      # Install KDE
      ./library/kde.sh | tee $INSTALL_LOG
      ;;
    4)
      # Install MATE
      ./library/mate.sh | tee $INSTALL_LOG
      ;;
    5)
      # Install XFCE
      ./library/xfce.sh | tee $INSTALL_LOG
      ;;
    *)
      echo "Wrong option"
      ;;
    esac

    # Install base applications
    ./library/baseapps.sh | tee $INSTALL_LOG

    # Update all
    pacman -Syu --noconfirm | tee $INSTALL_LOG

    # Reboot
    reboot
  fi
fi
