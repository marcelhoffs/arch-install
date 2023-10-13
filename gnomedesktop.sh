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
    # Define package arrays
    ARRAYINSTALL=()
    ARRAYREMOVE=()
    
    # Package files
    GNOMEINSTALL="packages/gnomeinstall"
    GNOMEREMOVE="packages/gnomeremove"
    GPUINTEL="packages/gpuintel"
    GPUAMD="packages/gpuamd"
    GPUNVIDIA="packages/gpunvidia"
    FONTS="packages/fonts"
    BASEAPPS="packages/baseapps"
    EXTRAAPPS="packages/extraapps"

    # Read gnome install packages 
    while read -r line
    do
      ARRAYINSTALL+=("$line")
    done < "$GNOMEINSTALL"

    # Read gnome remove packages 
    while read -r line
    do
      ARRAYREMOVE+=("$line")
    done < "$GNOMEREMOVE"

    # Read gpu install packages 
    case "$INSTALL_GPU" in
      INTEL)
        GPUINSTALL="$GPUINTEL";;
      AMD)
        GPUINSTALL="$GPUAMD";;
      NVIDIA)
        GPUINSTALL="$GPUNVIDIA";;
    esac

    while read -r line
    do
      ARRAYINSTALL+=("$line")
    done < "$GPUINSTALL"

    # Read fonts install packages 
    while read -r line
    do
      ARRAYINSTALL+=("$line")
    done < "$FONTS"

    # Read base install packages 
    while read -r line
    do
      ARRAYINSTALL+=("$line")
    done < "$BASEAPPS"

    # Read extra install packages 
    if [ "$EXTRA" == 'Y' ]; then
      while read -r line
      do
        ARRAYINSTALL+=("$line")
      done < "$EXTRAAPPS"
    fi

    # Install packages
    sudo pacman -S --noconfirm ${ARRAYINSTALL[@]} | tee -a "$INSTALL_LOG"

    # Remove packages
    sudo pacman -R --noconfirm ${ARRAYREMOVE[@]} | tee -a "$INSTALL_LOG"

    # Enable services
    sudo systemctl enable gdm
    sudo systemctl enable cups
    sudo systemctl enable avahi-daemon   

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