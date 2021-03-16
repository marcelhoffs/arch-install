#!/bin/bash
GREEN='\e[1;32m'
RED='\e[1;31m'
CYAN='\e[1;36m'
WHITe='\e[1;3m'
NC='\e[0m'

collect_parameters() {
  # What type of install
  while [ "$INSTALL_UEFI" != "BIOS" ] && [ "$INSTALL_UEFI" != "UEFI" ]; do
    read -p ' 1)  Install on BIOS or UEFI [BIOS/UEFI]: ' INSTALL_UEFI
    INSTALL_UEFI=${INSTALL_UEFI^^}
  done

  # If bios ask which device the OS will be installed on
  if [ $INSTALL_UEFI == 'BIOS' ]; then
    while [ "$INSTALL_DEVICE" == "" ]; do
      read -p ' 1a) On which device are you installing [e.g. /dev/sda]: ' INSTALL_DEVICE
    done
  fi

  # What CPU are you using
  while [ "$INSTALL_CPU" != "INTEL" ] && [ "$INSTALL_CPU" != "AMD" ]; do
    read -p ' 2)  Do you use an Intel or AMD CPU [INTEL/AMD]: ' INSTALL_CPU
    INSTALL_CPU=${INSTALL_CPU^^}
  done

  # Are you installing a virtual host
  while [ "$INSTALL_VIRTHOST" != "VMWARE" ] && [ "$INSTALL_VIRTHOST" != "VIRTUALBOX" ]; do
    read -p ' 3)  Are you installing on a virtual host [VMWARE/VIRTUALBOX]: ' INSTALL_VIRTHOST
    INSTALL_VIRTHOST=${INSTALL_VIRTHOST^^}
  done

  # Install LTS kernel
  while [ "$INSTALL_KERNEL_LTS" != "Y" ] && [ "$INSTALL_KERNEL_LTS" != "N" ]; do
    read -p ' 4)  Do you want to install the LTS kernel [Y/N]: ' INSTALL_KERNEL_LTS
    INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}
  done

  # Hostname
  while [ "$INSTALL_HOSTNAME" == "" ]; do
    read -p ' 5)  Provide the desired hostname: ' INSTALL_HOSTNAME
    INSTALL_HOSTNAME=${INSTALL_HOSTNAME,,}
  done

  # Root password
  while [ "$INSTALL_ROOT_PWD" == "" ]; do
    read -p ' 6)  Set root password: ' INSTALL_ROOT_PWD
  done

  # Root password
  while [ "$INSTALL_USER" == "" ]; do
    read -p ' 7)  Create new user: ' INSTALL_USER
  done

  # Root password
  while [ "$INSTALL_PASSWORD" == "" ]; do
    read -p ' 8)  Set new user password: ' INSTALL_PASSWORD
  done

  echo ''
  
  echo "hostname: " $INSTALL_HOSTNAME

  # Continue
  while [ "$INSTALL_CONTINUE" != "Y" ] && [ "$INSTALL_CONTINUE" != "N" ]; do
    read -p ' Are you sure you want to continue? [Y/N]: ' INSTALL_CONTINUE
    INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  done
}

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo "Please run as root privileges:"
  echo "sudo ./base.sh"
else
  # Clear screen
  clear
  echo -e "${CYAN}==============================================${NC}"
  echo -e "${RED} Arch Linux installation script               ${NC}"
  echo -e "${CYAN} Marcel Hoffs, 14.03.2021                     ${NC}"
  echo -e "${CYAN} Version 2.0                                  ${NC}"
  echo -e "${CYAN}==============================================${NC}"
  echo ''

  # Ask questions to collect installation parameters
  collect_parameters

  INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  if [ $INSTALL_CONTINUE == 'Y' ]; then
    # Make scripts executable
    chmod +x ./library/*.sh

    # Set hostname and hosts file
    ./library/hostname.sh $INSTALL_HOSTNAME

    # Set timezone
    ./library/timezone.sh

    # Install kernel
    INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}
    if [ $INSTALL_KERNEL_LTS == 'Y' ]; then
      ./library/kernel.sh LTS
    else
      ./library/kernel.sh
    fi

    # Install base packages
    ./library/basepackages.sh

    # Install CPU Microcode
    ./library/cpu.sh $INSTALL_CPU

    # Update pacman mirror list
    ./library/pacmanmirror.sh

    # Set locale
    ./library/locale.sh

    # Install bootloader
    ./library/bootloader.sh $INSTALL_UEFI $INSTALL_DEVICE

    # Install virtualization
    ./library/virtualization.sh $INSTALL_VIRTHOST

    # Enable services
    ./library/services.sh

    # Set root password
    ./library/rootpwd.sh $INSTALL_ROOT_PWD

    # Create user
    ./library/createuser.sh $INSTALL_USER $INSTALL_PASSWORD

    # Move installation files
    ./library/moveinstallation.sh $INSTALL_USER

    # Exit
    echo -e "${GREEN}==============================================${NC}"
    echo -e "${GREEN} Finished installing Arch base installation.  ${NC}"
    echo -e "${GREEN} Exit chroot : exit                           ${NC}"
    echo -e "${GREEN} Unmount all : umount -a                      ${NC}"
    echo -e "${GREEN} Then reboot : reboot                         ${NC}"
    echo -e "${GREEN}                                              ${NC}"
    echo -e "${GREEN} After reboot login with:                     ${NC}"
    echo -e "${GREEN} Username : ${NC}"${WHITE}$INSTALL_USER${NC}
    echo -e "${GREEN} Password : ${NC}"${WHITE}$INSTALL_PASSWORD${NC}
    echo -e "${GREEN}==============================================${NC}"
  else
    echo ''
    echo -e "${CYAN}==============================================${NC}"
    echo -e "${CYAN} Installation aborted.                        ${NC}"
    echo -e "${CYAN}==============================================${NC}"
    echo ''
  fi
fi
