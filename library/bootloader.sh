#!/bin/bash

# Install boot loader
echo ">> Installing GRUB bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg