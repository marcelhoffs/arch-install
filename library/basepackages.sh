#!/bin/bash

# Install base packages
echo ">> Installing base packages"
pacman -S --noconfirm grub efibootmgr dosfstools openssh os-prober mtools reflector networkmanager wpa_supplicant git curl wget htop neofetch bluez bluez-utils
