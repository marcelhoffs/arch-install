#!/bin/bash

KERNEL=$1
KERNEL=${KERNEL^^}

if [ $KERNEL == 'LTS' ]; then
  # Install linux long term support kernel
  echo ">> Installing Linux Long Term Support (LTS) kernel"
  pacman -S --noconfirm linux-lts linux-lts-headers linux-firmware
else
  # Install linux long term support kernel
  echo ">> Installing Linux kernel"
  pacman -S --noconfirm linux linux-headers linux-firmware
fi
