#!/bin/bash
if [ $# -eq 1 ]
  then
    echo "Setting hostname to: $1"
    echo $1 > /etc/hostname
  else
    echo "Provide a hostname."
    echo "Usage: hostname.sh <hostname>"
fi