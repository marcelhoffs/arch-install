#!/bin/bash

if [ "$EUID" -ne 0 ]
  then 
    # Not root
    echo "Please run as root privileges:"
    echo "sudo ./install_desktop.sh"
  else    
    # Execute base install script
    ./library/base.sh | tee install_desktop.log
fi