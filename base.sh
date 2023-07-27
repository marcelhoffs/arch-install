#!/bin/bash

# Constants
GREEN='\e[1;32m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
RED='\e[1;31m'
NC='\e[0m'
INSTALL_LOG='install_base.log'

collect_parameters() {
  # What keyboard are you using
  echo -e "${CYAN}"'1) Which keyboard layout do you want to use?'"${NC}"
  echo -e "${CYAN}"'   Examples: us, nl, be-latin1'"${NC}"  
  echo ''
  while [ "$INSTALL_KEYBOARD" == '' ]; do
    read -r -p 'Enter keyboard layout: ' INSTALL_KEYBOARD
    INSTALL_KEYBOARD=${INSTALL_KEYBOARD,,}
  done

  # What CPU are you using
  echo ''
  echo -e "${CYAN}"'2) Which brand of CPU are you using?'"${NC}"
  echo ''
  while [ "$INSTALL_CPU" != 'INTEL' ] && [ "$INSTALL_CPU" != 'AMD' ]; do
    read -r -p 'Enter CPU brand [INTEL/AMD]: ' INSTALL_CPU
    INSTALL_CPU=${INSTALL_CPU^^}
  done

  # Are you installing a virtual host
  echo ''
  echo -e "${CYAN}"'3) Are you installing on a virtual host?'"${NC}"
  echo ''
  while [ "$INSTALL_VIRTHOST" != 'VMWARE' ] && [ "$INSTALL_VIRTHOST" != 'VIRTUALBOX' ] && [ "$INSTALL_VIRTHOST" != 'QEMU' ] && [ "$INSTALL_VIRTHOST" != 'GNOMEBOXES' ] && [ "$INSTALL_VIRTHOST" != 'NONE' ] ; do
    read -r -p 'Enter virtualization host [VMWARE/VIRTUALBOX/QEMU/GNOMEBOXES/NONE]: ' INSTALL_VIRTHOST
    INSTALL_VIRTHOST=${INSTALL_VIRTHOST^^}
  done

  # Hostname
  echo ''
  echo -e "${CYAN}"'4) Set the hostname of this machine'"${NC}"
  echo ''
  while [ "$INSTALL_HOSTNAME" == '' ]; do
    read -r -p 'Enter hostname: ' INSTALL_HOSTNAME
    INSTALL_HOSTNAME=${INSTALL_HOSTNAME,,}
  done

  # Root password
  echo ''
  echo -e "${CYAN}"'5) Set the root password'"${NC}"
  echo ''
  while [ "$INSTALL_ROOT_PWD" == '' ]; do
    read -r -p 'Enter password: ' INSTALL_ROOT_PWD
  done

  # New user
  echo ''
  echo -e "${CYAN}"'6) Create new user'"${NC}"
  echo ''
  while [ "$INSTALL_USER" == '' ]; do
    read -r -p 'Username: ' INSTALL_USER
  done

  # New user password
  while [ "$INSTALL_PASSWORD" == '' ]; do
    read -r -p 'Password: ' INSTALL_PASSWORD
  done

  # Continue
  echo ''
  echo -e "${GREEN}"'Are you sure you want to continue?'"${NC}"
  echo ''
  while [ "$INSTALL_CONTINUE" != 'Y' ] && [ "$INSTALL_CONTINUE" != 'N' ]; do
    read -r -p 'Continue? [Y/N]: ' INSTALL_CONTINUE
    INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  done
}

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo 'Please run with root privileges:'
  echo 'sudo ./base.sh'
else
  # Clear screen
  clear
  echo -e "${CYAN}"'╔══════════════════════════════════════════════╗'"${NC}"
  echo -e "${CYAN}"'║ Arch Linux installation script               ║'"${NC}"
  echo -e "${CYAN}"'║ Marcel Hoffs, 25.07.2023                     ║'"${NC}"
  echo -e "${CYAN}"'║ Version 3.0                                  ║'"${NC}"
  echo -e "${CYAN}"'╚══════════════════════════════════════════════╝'"${NC}"
  echo ''

  # Ask questions to collect installation parameters
  collect_parameters

  INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  if [ "$INSTALL_CONTINUE" == 'Y' ]; then
    # Make scripts executable
    chmod +x ./library/*.sh | tee -a "$INSTALL_LOG"

    # Set hostname and hosts file
    ./library/hostname.sh "$INSTALL_HOSTNAME" | tee -a "$INSTALL_LOG"

    # Set timezone
    ./library/timezone.sh | tee -a "$INSTALL_LOG"

    # Install kernel
    ./library/kernel.sh | tee -a "$INSTALL_LOG"

    # Install base packages
    ./library/basepackages.sh | tee -a "$INSTALL_LOG"

    # Install CPU Microcode
    ./library/cpu.sh "$INSTALL_CPU" | tee -a "$INSTALL_LOG"

    # Update pacman mirror list
    ./library/pacmanmirror.sh | tee -a "$INSTALL_LOG"

    # Set locale
    ./library/locale.sh | tee -a "$INSTALL_LOG"

    # Set keyboard
    ./library/keyboard.sh "$INSTALL_KEYBOARD" | tee -a "$INSTALL_LOG"

    # Install bootloader
    ./library/bootloader.sh "$INSTALL_CPU" | tee -a "$INSTALL_LOG"

    # Install virtualization
    ./library/virtualization.sh "$INSTALL_VIRTHOST" | tee -a "$INSTALL_LOG"

    # Update all
    ./library/update.sh | tee -a "$INSTALL_LOG"

    # Enable services
    ./library/services.sh | tee -a "$INSTALL_LOG"

    # Set root password
    ./library/rootpwd.sh "$INSTALL_ROOT_PWD" | tee -a "$INSTALL_LOG"

    # Create user
    ./library/createuser.sh "$INSTALL_USER" "$INSTALL_PASSWORD" | tee -a "$INSTALL_LOG"

    # Move installation files
    ./library/moveinstallation.sh "$INSTALL_USER" | tee -a "$INSTALL_LOG"

    # Finish
    echo ''
    echo -e "${GREEN}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${GREEN}"' Finished installing Arch base installation.    '"${NC}"
    echo -e "${GREEN}"' Exit chroot : '"${WHITE}"'exit                 '"${NC}"
    echo -e "${GREEN}"' Unmount all : '"${WHITE}"'umount -a            '"${NC}"
    echo -e "${GREEN}"' Then reboot : '"${WHITE}"'reboot               '"${NC}"
    echo -e "${GREEN}"'                                                '"${NC}"
    echo -e "${GREEN}"' After reboot login with:                       '"${NC}"
    echo -e "${GREEN}"' Username : '"${WHITE}""$INSTALL_USER""${NC}"
    echo -e "${GREEN}"' Password : '"${WHITE}""$INSTALL_PASSWORD""${NC}"
    echo -e "${GREEN}"'════════════════════════════════════════════════'"${NC}"
    echo ''
  else
    echo ''
    echo -e "${RED}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${RED}"' Installation aborted.                          '"${NC}"
    echo -e "${RED}"'════════════════════════════════════════════════'"${NC}"
    echo ''
  fi
fi
