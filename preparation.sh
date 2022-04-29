#!/bin/bash

# Constants
CYAN='\e[1;36m'
NC='\e[0m'

collect_parameters() {
  # What keyboard are you using
  while [ "$INSTALL_KEYBOARD" == '' ]; do
    read -r -p ' 1)  What keyboard layout are you using : ' INSTALL_KEYBOARD
    INSTALL_KEYBOARD=${INSTALL_KEYBOARD,,}
  done  

  # What type of install
  while [ "$INSTALL_UEFI" != 'BIOS' ] && [ "$INSTALL_UEFI" != 'UEFI' ]; do
    read -r -p ' 2)  Install on BIOS or UEFI [BIOS/UEFI]: ' INSTALL_UEFI
    INSTALL_UEFI=${INSTALL_UEFI^^}
  done

  # Ask which device the OS will be installed on
  while [ "$INSTALL_DEVICE" == "" ]; do
      read -r -p ' 3) On which device are you installing [e.g. /dev/sda]: ' INSTALL_DEVICE
  done  
}

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo 'Please run with root privileges:'
  echo './preparation.sh'
else
  # Clear screen
  clear
  echo -e "${CYAN}"'╔══════════════════════════════════════════════╗'"${NC}"
  echo -e "${CYAN}"'║ Arch Linux preparation script                ║'"${NC}"
  echo -e "${CYAN}"'║ Marcel Hoffs, 29.04.2022                     ║'"${NC}"
  echo -e "${CYAN}"'║ Version 1.0                                  ║'"${NC}"
  echo -e "${CYAN}"'╚══════════════════════════════════════════════╝'"${NC}"
  echo ''

  # Ask questions to collect installation parameters
  collect_parameters

  # Set time and keyboard
  echo ''
  echo -e "${CYAN}"'>> Setting time and keyboard layout'"${NC}"
  
  timedatectl set-ntp true
  loadkeys "$INSTALL_KEYBOARD"
  
  # Partition drive
  echo ''
  echo -e "${CYAN}"'>> Partitioning and formating drive: '"$INSTALL_DEVICE""${NC}"
  
  # Remove all partitions
  sgdisk --zap-all "$INSTALL_DEVICE"
  
  if [ "$INSTALL_UEFI" == 'UEFI' ]; then
    # create EFI partition
    sgdisk --new 1::+500M --typecode 1:ef00 --change-name 1:EFI "$INSTALL_DEVICE"
  fi
  
  # create SWAP partition
  sgdisk --new 2::+2G --typecode 2:8200 --change-name 2:SWAP "$INSTALL_DEVICE"
  
  # create DATA parition
  sgdisk --new 3:: --typecode 3:8300 --change-name 3:DATA "$INSTALL_DEVICE"
  
  # partprobe
  partprobe "$INSTALL_DEVICE"
  
  if [ "$INSTALL_UEFI" == 'UEFI' ]; then
    # format EFI partition
    yes | mkfs.fat -F32 "$INSTALL_DEVICE"1

     # format SWAP partition
    yes | swapoff "$INSTALL_DEVICE"2 
    yes | mkswap "$INSTALL_DEVICE"2
    yes | swapon "$INSTALL_DEVICE"2
  
    # format DATA partition
    yes | mkfs.ext4 "$INSTALL_DEVICE"3

    # mount partitions
    mount "$INSTALL_DEVICE"3 /mnt
    mkdir -p /mnt/boot
    mount "$INSTALL_DEVICE"3 /mnt/boot
  else
    # format SWAP partition
    yes | swapoff "$INSTALL_DEVICE"1
    yes | mkswap "$INSTALL_DEVICE"1
    yes | swapon "$INSTALL_DEVICE"1
  
    # format DATA partition
    yes | mkfs.ext4 "$INSTALL_DEVICE"2

    # mount partitions
    mount "$INSTALL_DEVICE"2 /mnt
    mkdir -p /mnt/boot
    mount "$INSTALL_DEVICE"2 /mnt/boot
  fi

  # pacstrap
  pacstrap /mnt base base-devel vi nano git
  
  # generate fstab
  genfstab -U -p /mnt >> /mnt/etc/fstab
  
  # chroot
  arch-chroot /mnt
fi  
