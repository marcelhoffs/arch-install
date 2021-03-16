#!/bin/bash

# Update pacman mirrorlist
echo ">> Select fastest pacman mirror"
reflector --country Belgium --country Netherlands --country Germany --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
