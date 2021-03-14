#!/bin/bash

# Install base packages
echo ">> Installing base packages"
pacman -S --noconfirm grub efibootmgr dosfstools openssh os-prober mtools reflector networkmanager wpa_supplicant open-vm-tools git curl wget htop neofetch