#!/bin/bash

# Constants
GREEN='\e[1;32m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
RED='\e[1;31m'
NC='\e[0m'

collect_parameters() {
  # Ask which device the OS will be installed on
  echo -e "${CYAN}"'1) On which device do you want to install Arch Linux?'"${NC}"
  echo ''
  lsblk
  echo ''
  while [ "$INSTALL_DEVICE" == "" ]; do
    read -r -p 'Enter the device [e.g. /dev/sda]: ' INSTALL_DEVICE
  done

  # Swap file size
  echo ''
  echo -e "${CYAN}"'2) What should be the size of the swap partition?'"${NC}"
  echo ''
  while [ "$INSTALL_SWAPSIZE" == "" ]; do
    read -r -p 'Enter swap partition size (in Gb): ' INSTALL_SWAPSIZE
  done

  # File system
  echo ''
  echo -e "${CYAN}"'3) What filesystem do you want to use?'"${NC}"
  echo ''  
  while [ "$INSTALL_FS" != 'EXT4' ] && [ "$INSTALL_FS" != 'BTRFS' ]; do
    read -r -p 'Enter the file system [EXT4/BTRFS]: ' INSTALL_FS
    INSTALL_FS=${INSTALL_FS^^}
  done

  echo ''
  echo -e "${GREEN}"'Are you sure you want to continue?'"${NC}"
  echo '' 
  # Continue
  while [ "$INSTALL_CONTINUE" != 'Y' ] && [ "$INSTALL_CONTINUE" != 'N' ]; do
    read -r -p 'Continue? [Y/N]: ' INSTALL_CONTINUE
    INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  done
}

if [ "$EUID" -ne 0 ]; then
  # Not root
  echo 'Please run with root privileges:'
  echo './prep.sh'
else
  # Clear screen
  clear
  echo -e "${CYAN}"'╔══════════════════════════════════════════════╗'"${NC}"
  echo -e "${CYAN}"'║ Arch Linux preparation script                ║'"${NC}"
  echo -e "${CYAN}"'║ Marcel Hoffs, 27.07.2023                     ║'"${NC}"
  echo -e "${CYAN}"'║ Version 2.0                                  ║'"${NC}"
  echo -e "${CYAN}"'╚══════════════════════════════════════════════╝'"${NC}"
  echo ''

  # Ask questions to collect installation parameters
  collect_parameters

  INSTALL_CONTINUE=${INSTALL_CONTINUE^^}
  if [ "$INSTALL_CONTINUE" == 'Y' ]; then
    # Set time and keyboard
    echo ''
    echo -e "${CYAN}"'>> Setting time'"${NC}"
    timedatectl set-ntp true

    # ---------------------------------------------------------
    # Partition drive
    # ---------------------------------------------------------
    echo ''
    echo -e "${CYAN}"'>> Partitioning and formating drive: '"$INSTALL_DEVICE""${NC}"

    # Remove all partitions
    sgdisk --zap-all "$INSTALL_DEVICE"

    # create EFI, SWAP and DATA partition
    sgdisk --new 1::+500M --typecode 1:ef00 --change-name 1:EFI "$INSTALL_DEVICE"
    sgdisk --new 2::+"$INSTALL_SWAPSIZE"G --typecode 2:8200 --change-name 2:SWAP "$INSTALL_DEVICE"
    sgdisk --new 3:: --typecode 3:8300 --change-name 3:OS "$INSTALL_DEVICE"
   
    # partprobe and unmount everything
    partprobe "$INSTALL_DEVICE"
    umount -a

    # ---------------------------------------------------------
    # Format partitions
    # ---------------------------------------------------------

    # get devices by label
    PART_EFI=$(blkid -t PARTLABEL=EFI -o device)
    PART_SWAP=$(blkid -t PARTLABEL=SWAP -o device)
    PART_OS=$(blkid -t PARTLABEL=OS -o device)

    # format EFI partition
    yes | mkfs.fat -F32 "$PART_EFI"
    
    # format SWAP partition
    yes | swapoff "$PART_SWAP"
    yes | mkswap "$PART_SWAP"
    yes | swapon "$PART_SWAP"

    if [ "$INSTALL_FS" == 'EXT4' ]; then
      # format DATA partition
      yes | mkfs.ext4 "$PART_OS"
    fi
    
    if [ "$INSTALL_FS" == 'BTRFS' ]; then
      # format DATA partition
      mkfs.btrfs --force "$PART_OS" 
    fi

    # ---------------------------------------------------------
    # Mount partitions
    # ---------------------------------------------------------

    # mount OS partition
    mount "$PART_OS" /mnt

    # if BTRFS create subvolumes and mount
    if [ "$INSTALL_FS" == 'BTRFS' ]; then
      btrfs subvolume create /mnt/@
      btrfs subvolume create /mnt/@home
      umount /mnt
      mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ "$PART_OS" /mnt
      mkdir -p /mnt/home
      mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home "$PART_OS" /mnt/home
    fi

    # mount EFI partition
    mkdir -p /mnt/boot
    mount "$PART_EFI" /mnt/boot

    # ---------------------------------------------------------
    # Pacstrap and generate fstab
    # ---------------------------------------------------------
    
    # restart pacman-init
    systemctl restart pacman-init.service
    
    # pacstrap
    pacstrap -K /mnt base base-devel vi nano git

    # generate fstab
    genfstab -U -p /mnt >>/mnt/etc/fstab

    # chroot
    arch-chroot /mnt
  else
    echo ''
    echo -e "${RED}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${RED}"' Installation aborted.                          '"${NC}"
    echo -e "${RED}"'════════════════════════════════════════════════'"${NC}"
    echo ''
  fi
fi
