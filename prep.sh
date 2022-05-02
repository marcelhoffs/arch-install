#!/bin/bash

# Constants
CYAN='\e[1;36m'
NC='\e[0m'

collect_parameters() {
  # What type of install
  while [ "$INSTALL_UEFI" != 'BIOS' ] && [ "$INSTALL_UEFI" != 'UEFI' ]; do
    read -r -p ' 1)  Install on BIOS or UEFI [BIOS/UEFI]: ' INSTALL_UEFI
    INSTALL_UEFI=${INSTALL_UEFI^^}
  done

  # Ask which device the OS will be installed on
  while [ "$INSTALL_DEVICE" == "" ]; do
    read -r -p ' 2)  On which device are you installing [e.g. /dev/sda]: ' INSTALL_DEVICE
  done

  # Swap file size
  while [ "$INSTALL_SWAPSIZE" == "" ]; do
    read -r -p ' 3)  What should be the size of the swap partition (in Gb): ' INSTALL_SWAPSIZE
  done

  # File system
  while [ "$INSTALL_FS" != 'EXT4' ] && [ "$INSTALL_FS" != 'BTRFS' ]; do
    read -r -p ' 4)  What filesystem do you wnt to use [EXT4/BTRFS]: ' INSTALL_FS
    INSTALL_FS=${INSTALL_FS^^}
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

    if [ "$INSTALL_UEFI" == 'UEFI' ]; then
      # create EFI, SWAP and DATA partition
      sgdisk --new 1::+500M --typecode 1:ef00 --change-name 1:EFI "$INSTALL_DEVICE"
      sgdisk --new 2::+"$INSTALL_SWAPSIZE"G --typecode 2:8200 --change-name 2:SWAP "$INSTALL_DEVICE"
      sgdisk --new 3:: --typecode 3:8300 --change-name 3:OS "$INSTALL_DEVICE"
    else
      # create SWAP and DATA partition
      sgdisk --new 1::+"$INSTALL_SWAPSIZE"G --typecode 1:8200 --change-name 1:SWAP "$INSTALL_DEVICE"
      sgdisk --new 2:: --typecode 2:8300 --change-name 2:OS "$INSTALL_DEVICE"
    fi

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

    if [ "$INSTALL_UEFI" == 'UEFI' ]; then
      # format EFI partition
      yes | mkfs.fat -F32 "$PART_EFI"
    fi

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
      yes | mkfs.btrfs "$PART_OS" 
    fi

    # ---------------------------------------------------------
    # Mount partitions
    # ---------------------------------------------------------

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

    if [ "$INSTALL_UEFI" == 'UEFI' ]; then
      mkdir -p /mnt/boot
      mount "$PART_EFI" /mnt/boot
    fi

    # ---------------------------------------------------------
    # Pacstrap and generate fstab
    # ---------------------------------------------------------

    # pacstrap
    pacstrap /mnt base base-devel vi nano git

    # generate fstab
    genfstab -U -p /mnt >>/mnt/etc/fstab

    # chroot
    arch-chroot /mnt
  else
    echo ''
    echo -e "${CYAN}"'════════════════════════════════════════════════'"${NC}"
    echo -e "${CYAN}"' Installation aborted.                          '"${NC}"
    echo -e "${CYAN}"'════════════════════════════════════════════════'"${NC}"
    echo ''
  fi
fi
