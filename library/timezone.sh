#!/bin/bash
if [ $# -eq 1 ]
  then
    # Set timezone
    echo ">> Setting timezone to: $1"
    ln -sf /usr/share/zoneinfo/$1 /etc/localtime
    hwclock --systohc
  else
    echo "Provide a timezone"
    echo "Usage: timezone.sh <timezone>"
fi