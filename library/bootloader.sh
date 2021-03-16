#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

INSTALL_TYPE=$1
INSTALL_DEV=$2

INSTALL_TYPE=${INSTALL_TYPE^^}

# Install boot loader
if [ $INSTALL_TYPE = 'UEFI' ]; then
  echo -e "${CYAN}>> Installing GRUB bootloader (UEFI)${NC}"
  grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=grub_uefi --recheck
  grub-mkconfig -o /boot/grub/grub.cfg
fi

if [ $INSTALL_TYPE = 'BIOS' ]; then
  echo -e "${CYAN}>> Installing GRUB bootloader (BIOS)${NC}"
  grub-install --target=i386-pc $INSTALL_DEV
  grub-mkconfig -o /boot/grub/grub.cfg
fi
