#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install base packages
echo ''
echo -e "${CYAN}"'>> Installing base packages'"${NC}"
pacman -S --noconfirm efibootmgr dosfstools openssh reflector networkmanager git curl wget neofetch bluez bluez-utils btrfs-progs archlinux-keyring zip unzip unrar fwupd
