#!/bin/bash

INSTALL_TYPE=$1
INSTALL_DEV=$2

INSTALL_TYPE=${INSTALL_TYPE^^}
INSTALL_DEV=${INSTALL_DEV^^}

# Install boot loader
if [ $INSTALL_TYPE = 'UEFI' ]
  then
    echo ">> Installing GRUB bootloader"
    grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=grub_uefi --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
fi

if [ $INSTALL_TYPE = 'BIOS' ]
  then
    echo ">> Installing GRUB bootloader (BIOS)"
    grub-install --target=i386-pc $INSTALL_DEV
    grub-mkconfig -o /boot/grub/grub.cfg
fi