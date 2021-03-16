#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

# Install base packages
echo "${CYAN}>> Installing base packages${NC}"
pacman -S --noconfirm grub efibootmgr dosfstools openssh os-prober mtools reflector networkmanager wpa_supplicant git curl wget htop neofetch bluez bluez-utils
