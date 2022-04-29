#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

DRIVE=$1
DRIVE=${DRIVE,,}

# Partition drive
echo ''
echo -e "${CYAN}"'>> Partitioning and formating drive: '"$KEYBOARD""${NC}"

# Remove all partitions
#sgdisk --zap-all /dev/sda

# create EFI partition
#sgdisk --new 1::+500M --typecode 1:ef00 --change-name 1:EFI /dev/sda

# create SWAP partition
#sgdisk --new 2::+8G --typecode 2:8200 --change-name 2:SWAP /dev/sda

# create DATA parition
#sgdisk --new 3:: --typcode 2:8300 --change-name 3:DATA /dev/sda

# format EFI partition
#mkfs.fat -F32 /dev/sda1

# format SWAP partition
#mkswap /dev/sda2
#swapon /dev/sda2

# format DATA partition
#mkfs.ext4 /dev/sda3