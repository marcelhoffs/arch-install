#!/bin/bash

if [ $# -eq 1 ]
  then
    # Set root password
    echo '>> Setting root password'
    echo root:$1 | chpasswd  
  else
    echo "Provide a password."
    echo "Usage: rootpwd.sh <password>"
fi