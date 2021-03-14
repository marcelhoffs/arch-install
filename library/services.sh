#!/bin/bash

# Enable services
echo ">> Enable services"
systemctl enable sshd
systemctl enable NetworkManager
systemctl enable bluetooth