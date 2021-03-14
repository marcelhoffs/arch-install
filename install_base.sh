#!/bin/bash

# Make scripts executable
chmod +x /library/*.sh

# Execute base install script
./library/base.sh | tee install_base.log