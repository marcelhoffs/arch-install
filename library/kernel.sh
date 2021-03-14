#!/bin/bash
if [ $1 == 'LTS' ]
  then
    # Install linux long term support kernel
    echo ">> Installing Linux Long Term Support (LTS) kernel"
    pacman -S linux-lts linux-lts-headers linux-firmware
  else
    # Install linux long term support kernel
    echo ">> Installing Linux kernel"
    pacman -S linux linux-headers linux-firmware
fi