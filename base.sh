#!/bin/bash

# Constants
GREEN='\e[1;32m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
NC='\e[0m'
INSTALL_LOG='install_base.log'

collect_parameters() {
  # What type of install
  while [ "$INSTALL_UEFI" != 'BIOS' ] && [ "$INSTALL_UEFI" != 'UEFI' ]; do
    read -r -p ' 1)  Install on BIOS or UEFI [BIOS/UEFI]: ' INSTALL_UEFI
    INSTALL_UEFI=${INSTALL_UEFI^^}
  done

  # If bios ask which device the OS will be installed on
  if [ "$INSTALL_UEFI" == 'BIOS' ]; then
    while [ "$INSTALL_DEVICE" == "" ]; do
      read -r -p ' 1a) On which device are you installing [e.g. /dev/sda]: ' INSTALL_DEVICE
    done
  fi

  # What keyboard are you using
  while [ "$INSTALL_KEYBOARD" == '' ]; do
    read -r -p ' 2)  What keyboard layout are you using : ' INSTALL_KEYBOARD
    INSTALL_KEYBOARD=${INSTALL_KEYBOARD,,}
  done

  # What CPU are you using
  while [ "$INSTALL_CPU" != 'INTEL' ] && [ "$INSTALL_CPU" != 'AMD' ]; do
    read -r -p ' 3)  Do you use an Intel or AMD CPU [INTEL/AMD]: ' INSTALL_CPU
    INSTALL_CPU=${INSTALL_CPU^^}
  done

  # Are you installing a virtual host
  while [ "$INSTALL_VIRTHOST" != 'VMWARE' ] && [ "$INSTALL_VIRTHOST" != 'VIRTUALBOX' ] && [ "$INSTALL_VIRTHOST" != 'QEMU' ] && [ "$INSTALL_VIRTHOST" != 'NONE' ]; do
    read -r -p ' 4)  Are you installing on a virtual host [VMWARE/VIRTUALBOX/QEMU/NONE]: ' INSTALL_VIRTHOST
    INSTALL_VIRTHOST=${INSTALL_VIRTHOST^^}
  done

  # Install LTS kernel
  while [ "$INSTALL_KERNEL_LTS" != 'Y' ] && [ "$INSTALL_KERNEL_LTS" != 'N' ]; do
    read -r -p ' 5)  Do you want to install the LTS kernel [Y/N]: ' INSTALL_KERNEL_LTS
    INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}
  done

  # Hostname
  while [ "$INSTALL_HOSTNAME" == '' ]; do
    read -r -p ' 6)  Provide the desired hostname: ' INSTALL_HOSTNAME
    INSTALL_HOSTNAME=${INSTALL_HOSTNAME,,}
  done

  # Root password
  while [ "$INSTALL_ROOT_PWD" == '' ]; do
    read -r -p ' 7)  Set root password: ' INSTALL_ROOT_PWD
  done

  # Root password
  while [ "$INSTALL_USER" == '' ]; do
    read -r -p ' 8)  Create new user: ' INSTALL_USER
  done

  # Root password
  while [ "$INSTALL_PASSWORD" == '' ]; do
    read -r -p ' 9)  Set new user password: ' INSTALL_PASSWORD
  done

  echo ''

  # Continue
  while [ "$INSTALL_CONTINUE" != 'Y' ] && [ "$INSTALL_CONTINUE" != 'N' ]; do
    read -r -p ' Are you sure you want to continue? [Y/N]: ' INSTALL_CONTINUE
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
  echo -e "${CYAN}"'║ Marcel Hoffs, 14.03.2021                     ║'"${NC}"
  echo -e "${CYAN}"'║ Version 2.0                                  ║'"${NC}"
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
    ./library/kernel.sh "$INSTALL_KERNEL_LTS" | tee -a "$INSTALL_LOG"

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
    ./library/bootloader.sh "$INSTALL_UEFI" "$INSTALL_DEVICE" "$INSTALL_CPU" "$INSTALL_KERNEL_LTS" | tee -a "$INSTALL_LOG"

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
    echo -e "${CYAN}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${CYAN}"' Installation aborted.                          '"${NC}"
    echo -e "${CYAN}"'════════════════════════════════════════════════'"${NC}"
    echo ''
  fi
fi
