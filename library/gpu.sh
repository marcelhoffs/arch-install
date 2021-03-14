#!/bin/bash

# Install graphics drivers
echo ">> Installing graphics drivers"
pacman -S --noconfirm mesa xf86-video-vesa xf86-video-vmware xf86-video-fbdev vulkan-intel