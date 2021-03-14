#!/bin/bash

# Install XFCE
echo ">> Installing XFCE"
pacman -S --noconfirm lightdm lightdm-gtk-greeter xfce4 xfce4-goodies gnome-bluetooth 

# Enable services
systemctl enable lightdm
