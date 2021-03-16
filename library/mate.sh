#!/bin/bash

# Install MATE
echo ">> Installing MATE"
pacman -S --noconfirm lightdm lightdm-gtk-greeter mate mate-extra network-manager-applet blueman mate-power-manager

# Enable services
systemctl enable lightdm
