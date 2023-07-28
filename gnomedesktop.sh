#!/bin/bash
GREEN='\e[1;32m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
RED='\e[1;31m'
NC='\e[0m'
INSTALL_LOG='install_desktop.log'

if [ "$EUID" -ne 0 ]; then
  # Ask what desktop to install
  clear
  echo -e "${CYAN}"'╔══════════════════════════════════════════════╗'"${NC}"
  echo -e "${CYAN}"'║ GNOME Desktop Environment installation       ║'"${NC}"
  echo -e "${CYAN}"'║ Marcel Hoffs, 25.07.2023                     ║'"${NC}"
  echo -e "${CYAN}"'║ Version 2.0                                  ║'"${NC}"
  echo -e "${CYAN}"'╚══════════════════════════════════════════════╝'"${NC}"
  
  # What GPU are you using
  echo ''
  echo -e "${CYAN}"'1) What GPU are you using?'"${NC}"
  echo ''
  while [ "$INSTALL_GPU" != 'INTEL' ] && [ "$INSTALL_GPU" != 'AMD' ] && [ "$INSTALL_GPU" != 'NVIDIA' ]; do
    read -r -p 'Enter GPU brand [INTEL/AMD/NVIDIA]: ' INSTALL_GPU
    INSTALL_GPU=${INSTALL_GPU^^}
  done

  # Install extra applications
  echo ''
  echo -e "${CYAN}"'2) Do you want to install extra applications?'"${NC}"
  echo -e "${CYAN}"'   The following applications will be installed:'"${NC}"
  echo -e "${CYAN}"'   - Mozilla Thunderbird'"${NC}"
  echo -e "${CYAN}"'   - Gimp'"${NC}"
  echo -e "${CYAN}"'   - LibreOffice'"${NC}"
  echo -e "${CYAN}"'   - Bitwarden'"${NC}"
  echo -e "${CYAN}"'   - Remmina'"${NC}"
  echo -e "${CYAN}"'   - Gnome Boxes'"${NC}"
  echo ''
  while [ "$EXTRA" != 'Y' ] && [ "$EXTRA" != 'N' ]; do
    read -r -p 'Install [Y/N]: ' EXTRA
    EXTRA=${EXTRA^^}
  done

  # Continue
  echo ''
  echo -e "${GREEN}"'Are you sure you want to continue?'"${NC}"
  echo ''
  while [ "$INSTALL_CONTINUE" != 'Y' ] && [ "$INSTALL_CONTINUE" != 'N' ]; do
    read -r -p 'Continue? [Y/N]: ' INSTALL_CONTINUE
    INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  done

  # Continue if not aborted
  if [ "$INSTALL_CONTINUE" == 'N' ]; then
    echo ''
    echo -e "${RED}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${RED}"' Installation aborted.                        '"${NC}"
    echo -e "${RED}"'════════════════════════════════════════════════'"${NC}"
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

    if [ "$EXTRA" == 'Y' ]; then
      sudo ./library/extraapps.sh | tee -a "$INSTALL_LOG"
    fi

    # Update all
    sudo ./library/update.sh | tee -a "$INSTALL_LOG"

    # Set defaults
    ./library/gnomedefaults.sh | tee -a "$INSTALL_LOG"

    echo ''
    echo -e "${GREEN}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${GREEN}"' Installation finalized, now reboot.            '"${NC}"
    echo -e "${GREEN}"'════════════════════════════════════════════════'"${NC}"
    echo ''
  fi
else
  # Root
  echo 'Please run as a regular user:'
  echo './desktop.sh'
fi
