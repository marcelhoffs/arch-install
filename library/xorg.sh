#!/bin/bash

# Install X.org packages
echo ">> Installing X.org packages"
pacman -S --noconfirm xorg-server xorg-xinit xorg-apps