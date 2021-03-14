#!/bin/bash
if [ $1 == 'LTS' ]
  then
    # Install linux long term support kernel
    pacman -S linux-lts linux-lts-headers linux-firmware
  else
    # Install linux long term support kernel
    pacman -S linux linux-headers linux-firmware
fi