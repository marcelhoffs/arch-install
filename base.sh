#!/bin/bash

# Ask some questions
read -p 'Provide the desired hostname: ' INSTALL_HOSTNAME
read -p 'Provide the desired hostname: ' INSTALL_TIMEZONE

# Set hostname and hosts file
./library/hostname.sh $INSTALL_HOSTNAME

# Set timezone
#./libary/timezone.sh $INSTALL_TIMEZONE