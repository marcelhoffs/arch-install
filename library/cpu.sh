#!/bin/bash

# Install CPU specific microcode
if [ $1 == 'INTEL' ]
  then
    echo ">> Installing Intel packages"
    pacman -S --noconfirm intel-ucode iucode-tool
fi
if [ $1 == 'AMD' ]
  then
    echo ">> Installing AMD packages"
    pacman -S --noconfirm amd-ucode
fi