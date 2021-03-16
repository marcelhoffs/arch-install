#!/bin/bash

# Set timezone
echo ">> Setting timezone to: Europe/Brussels"
ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc
