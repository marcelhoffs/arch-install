#!/bin/bash

# Ask some questions
read -p 'Provide the desired hostname: ' INSTALL_HOSTNAME
read -p 'Do you want to install the LTS kernel [Y/N]: ' INSTALL_KERNEL_LTS

# Make script executable
chmod +x library/*.sh

# Set hostname and hosts file
./library/hostname.sh $INSTALL_HOSTNAME

# Set timezone
./library/timezone.sh

# Install kernel
INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}
if [ $INSTALL_KERNEL_LTS == 'Y' ]
  ./library/kernel.sh LTS
else
  ./library/kernel.sh
fi