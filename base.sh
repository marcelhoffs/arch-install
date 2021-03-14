#!/bin/bash

# Ask some questions
read -p 'Provide the desired hostname: ' INSTALL_HOSTNAME

# Make script executable
chmod +x library/*.sh

# Set hostname and hosts file
./library/hostname.sh $INSTALL_HOSTNAME

# Set timezone
./library/timezone.sh