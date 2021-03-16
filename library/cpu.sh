#!/bin/bash

CPU=$1
CPU=${CPU^^}

# Install CPU specific microcode
if [ $CPU == 'INTEL' ]; then
  echo ">> Installing Intel packages"
  pacman -S --noconfirm intel-ucode iucode-tool
fi

if [ $CPU == 'AMD' ]; then
  echo ">> Installing AMD packages"
  pacman -S --noconfirm amd-ucode
fi
