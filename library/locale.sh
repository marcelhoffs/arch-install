#!/bin/bash

# Set locale
echo ">> Set locale"
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# en_NL.UTF-8 UTF-8/en_NL.UTF-8 UTF-8/' /etc/locale.gen
sed -i -e 's/# en_BE.UTF-8 UTF-8/en_BE.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf