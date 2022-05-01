#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

INSTALL_TYPE=$1
INSTALL_DEV=$2
INSTALL_CPU=$3
INSTALL_KERNEL_LTS=$4

INSTALL_TYPE=${INSTALL_TYPE^^}
INSTALL_CPU=${INSTALL_CPU^^}
INSTALL_KERNEL_LTS=${INSTALL_KERNEL_LTS^^}

# Install boot loader
# For UEFI use systemd-boot
if [ "$INSTALL_TYPE" = 'UEFI' ]; then
  echo ''
  echo -e "${CYAN}"'>> Installing systemd bootloader (UEFI)'"${NC}"
  
  # Install
  bootctl install
  
  # Create loader file
  echo 'default archlinux' >/boot/loader/loader.conf
  echo 'timeout 3' >>/boot/loader/loader.conf

  # Create entry file
  echo 'title Arch Linux' >/boot/loader/entries/archlinux.conf
  if [ "$INSTALL_KERNEL_LTS" == 'Y' ]; then
    echo 'linux /vmlinuz-linux-lts' >>/boot/loader/entries/archlinux.conf 
  else
    echo 'linux /vmlinuz-linux' >>/boot/loader/entries/archlinux.conf 
  fi

  if [ "$INSTALL_CPU" = 'INTEL' ] 
    echo 'initrd /intel-ucode.img' >>/boot/loader/entries/archlinux.conf  
  fi
  if [ "$INSTALL_CPU" = 'AMD' ] 
    echo 'initrd /amd-ucode.img' >>/boot/loader/entries/archlinux.conf  
  fi

  if [ "$INSTALL_KERNEL_LTS" == 'Y' ]; then
    echo 'initrd /initramfs-linux-lts.img' >>/boot/loader/entries/archlinux.conf 
  else
    echo 'initrd /initramfs-linux.img' >>/boot/loader/entries/archlinux.conf 
  fi

  echo 'options root='$(blkid -t PARTLABEL=DATA -o export | grep PARTUUID) >>/boot/loader/entries/archlinux.conf  

  # Enable update service
  systemctl enable systemd-boot-update.service
fi

# For BIOS use GRUB
if [ "$INSTALL_TYPE" = 'BIOS' ]; then
  echo ''
  echo -e "${CYAN}"'>> Installing GRUB bootloader (BIOS)'"${NC}"
  grub-install --target=i386-pc --force "$INSTALL_DEV"
  grub-mkconfig -o /boot/grub/grub.cfg
fi
