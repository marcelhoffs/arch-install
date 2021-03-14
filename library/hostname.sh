#!/bin/bash
if [ $# -eq 1 ]
  then
    # Create hostname (/etc/hostname)
    echo ">> Setting hostname to: $1"
    echo $1 > /etc/hostname
    
    # Create hosts file (/etc/hosts)+
    echo ">> Creating hosts file"
    echo '# Static table lookup for hostnames.' > /etc/hosts
    echo '# See hosts(5) for details.' >> /etc/hosts
    echo '127.0.0.1 localhost' >> /etc/hosts
    echo '::1 localhost' >> /etc/hosts
    echo '127.0.1.1 '$1'.localdomain '$1 >> /etc/hosts
  else
    echo "Provide a hostname."
    echo "Usage: hostname.sh <hostname>"
fi