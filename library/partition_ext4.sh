#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

DRIVE=$1
DRIVE=${DRIVE,,}

# Partition drive
echo ''
echo -e "${CYAN}"'>> Partitioning and formating drive: '"$DRIVE""${NC}"

# Remove all partitions
sgdisk --zap-all "$DRIVE"

# create EFI partition
sgdisk --new 1::+500M --typecode 1:ef00 --change-name 1:EFI "$DRIVE"

# create SWAP partition
sgdisk --new 2::+8G --typecode 2:8200 --change-name 2:SWAP "$DRIVE"

# create DATA parition
sgdisk --new 3:: --typecode 2:8300 --change-name 3:DATA "$DRIVE"

# partprobe
partprobe "$DRIVE"

# format EFI partition
yes | mkfs.fat -F32 "$DRIVE"1

# format SWAP partition
yes | mkswap "$DRIVE"2
yes | swapon "$DRIVE"2

# format DATA partition
yes | mkfs.ext4 "$DRIVE"3