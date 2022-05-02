#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

INSTALL_CPU=$1

INSTALL_CPU=${INSTALL_CPU^^}

# Install boot loader
echo ''
echo -e "${CYAN}"'>> Installing systemd bootloader (UEFI)'"${NC}"

# Install
bootctl install

# Create loader file
echo 'default archlinux' >/boot/loader/loader.conf
echo 'timeout 3' >>/boot/loader/loader.conf

# Create entry file
echo 'title Arch Linux' >/boot/loader/entries/archlinux.conf
echo 'linux /vmlinuz-linux' >>/boot/loader/entries/archlinux.conf
echo 'initrd /initramfs-linux.img' >>/boot/loader/entries/archlinux.conf

# Set the cpu microcode
if [ "$INSTALL_CPU" = 'INTEL' ]; then
  echo 'initrd /intel-ucode.img' >>/boot/loader/entries/archlinux.conf
fi
if [ "$INSTALL_CPU" = 'AMD' ]; then
  echo 'initrd /amd-ucode.img' >>/boot/loader/entries/archlinux.conf
fi

# Set the OS device
DEVICES_FS=$(blkid -t PARTLABEL=OS -o export | grep TYPE)
if [ "$DEVICES_FS" = 'TYPE=btrfs' ]; then
  echo 'options root='"$(blkid -t PARTLABEL=OS -o export | grep PARTUUID)"' rootflags=subvol=@ rw' >>/boot/loader/entries/archlinux.conf    
  sed -i -e 's/MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf
  mkinitcpio -P
else
  echo 'options root='"$(blkid -t PARTLABEL=OS -o export | grep PARTUUID)" >>/boot/loader/entries/archlinux.conf
fi
 
# Enable update service
systemctl enable systemd-boot-update