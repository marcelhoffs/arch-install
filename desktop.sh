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

     # What GPU are you using
     echo ''
     while [ "$INSTALL_CPU" != "INTEL" ] && [ "$INSTALL_CPU" != "AMD" ] && [ "$INSTALL_CPU" != "NVIDIA" ]; do
       read -p ' What GPU are you using? [INTEL/AMD/NVIDIA]: ' INSTALL_GPU
       INSTALL_GPU=${INSTALL_CPU^^}
     done

     # Ask extra question if it is Nvidia
     if [ $INSTALL_GPU == 'NVIDIA' ]; then
       while [ "$INSTALL_KERNEL_LTS" != "Y" ] && [ "$INSTALL_KERNEL_LTS" != "N" ]; do
         read -p ' Are you using the LTS kernel [Y/N]: ' INSTALL_KERNEL_LTS
         INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}
       done
     fi

     # Continue
     echo ''
     while [ "$INSTALL_CONTINUE" != "Y" ] && [ "$INSTALL_CONTINUE" != "N" ]; do
       read -p ' Are you sure you want to continue? [Y/N]: ' INSTALL_CONTINUE
       INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
     done
  done

  # Continue if not aborted
  if [ $INSTALL_CONTINUE == 'Y' ]; then
    echo ''
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${CYAN} Installation aborted.                        ${NC}"
    echo -e "${CYAN}==============================================${NC}"
    echo ''
  else
    # Install X.org
    ./library/xorg.sh | tee -a $INSTALL_LOG

    # Install graphics drivers
    ./library/gpu.sh $INSTALL_GPU $INSTALL_KERNEL_LTS | tee -a $INSTALL_LOG

    # Install fonts
    ./library/fonts.sh | tee -a $INSTALL_LOG

    case $INSTALL_DE in
    1)
      # Install GNOME
      ./library/gnome.sh | tee -a $INSTALL_LOG
      ;;
    2)
      # Install GNOME
      ./library/gnome.sh MINIMAL | tee -a $INSTALL_LOG
      ;;
    3)
      # Install KDE
      ./library/kde.sh | tee -a $INSTALL_LOG
      ;;
    4)
      # Install MATE
      ./library/mate.sh | tee -a $INSTALL_LOG
      ;;
    5)
      # Install XFCE
      ./library/xfce.sh | tee -a $INSTALL_LOG
      ;;
    *)
      echo "Wrong option"
      ;;
    esac

    # Install base applications
    ./library/baseapps.sh | tee -a $INSTALL_LOG

    # Update all
    ./library/update.sh | tee -a $INSTALL_LOG

    # Reboot
    reboot
  fi
fi
