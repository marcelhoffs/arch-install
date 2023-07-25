#!/bin/bash
CYAN='\e[1;36m'
WHITE='\e[1;37m'
NC='\e[0m'
INSTALL_LOG='install_desktop.log'

if [ "$EUID" -ne 0 ]; then
  # Ask what desktop to install
  clear
  echo -e "${CYAN}"'╔══════════════════════════════════════════════╗'"${NC}"
  echo -e "${CYAN}"'║ Arch Linux Desktop Environment installation  ║'"${NC}"
  echo -e "${CYAN}"'║ Marcel Hoffs, 25.07.2023                     ║'"${NC}"
  echo -e "${CYAN}"'║ Version 1.1                                  ║'"${NC}"
  echo -e "${CYAN}"'╚══════════════════════════════════════════════╝'"${NC}"
  echo ''
  echo ' Installing Gnome Desktop'
  
  # What GPU are you using
  echo ''
  while [ "$INSTALL_GPU" != 'INTEL' ] && [ "$INSTALL_GPU" != 'AMD' ] && [ "$INSTALL_GPU" != 'NVIDIA' ]; do
    read -r -p ' What GPU are you using? [INTEL/AMD/NVIDIA]: ' INSTALL_GPU
    INSTALL_GPU=${INSTALL_GPU^^}
  done
    # Continue
  echo ''
  while [ "$INSTALL_CONTINUE" != 'Y' ] && [ "$INSTALL_CONTINUE" != 'N' ]; do
    read -r -p ' Are you sure you want to continue? [Y/N]: ' INSTALL_CONTINUE
    INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  done

  # Continue if not aborted
  if [ "$INSTALL_CONTINUE" == 'N' ]; then
    echo ''
    echo -e "${CYAN}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${CYAN}"' Installation aborted.                        '"${NC}"
    echo -e "${CYAN}"'════════════════════════════════════════════════'"${NC}"
    echo ''
  else
    # Install graphics drivers
    sudo ./library/gpu.sh "$INSTALL_GPU" | tee -a "$INSTALL_LOG"

    # Install fonts
    sudo ./library/fonts.sh | tee -a "$INSTALL_LOG"

    # Install GNOME
    sudo ./library/gnome.sh | tee -a "$INSTALL_LOG"

    # Install base applications
    sudo ./library/baseapps.sh | tee -a "$INSTALL_LOG"

    # Update all
    sudo ./library/update.sh | tee -a "$INSTALL_LOG"

    # Set defaults
    ./library/gnomedefaults.sh | tee -a "$INSTALL_LOG"

    # Reboot
    sudo reboot
  fi
else
  # Root
  echo 'Please run as a regular user:'
  echo './desktop.sh'
fi
