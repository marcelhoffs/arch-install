#!/bin/bash
CYAN='\e[1;36m'
NC='\e[0m'

VMHOST=$1
VMHOST=${VMHOST^^}

# VMware virtualization
if [ "$VMHOST" == 'VMWARE' ]; then
  echo ''
  echo -e "${CYAN}"'>> Enable VMware guest tools'"${NC}"
  pacman -S --noconfirm open-vm-tools xf86-video-vmware
  systemctl enable vmtoolsd
  systemctl enable vmware-vmblock-fuse

  # Load kernel modules
  DEVICES_FS=$(blkid -t PARTLABEL=OS -o export | grep TYPE)
  DEVICES_FS=${DEVICES_FS^^}

  if [ "$DEVICES_FS" = 'TYPE=EXT4' ]; then
    sed -i -e 's/MODULES=()/MODULES=(vsock vmw_vsock_vmci_transport vmw_balloon vmw_vmci vmwgfx)/' /etc/mkinitcpio.conf
  fi
  
  if [ "$DEVICES_FS" = 'TYPE=BTRFS' ]; then
    sed -i -e 's/MODULES=(btrfs)/MODULES=(btrfs vsock vmw_vsock_vmci_transport vmw_balloon vmw_vmci vmwgfx)/' /etc/mkinitcpio.conf
  fi  
  
  mkinitcpio -P
fi

if [ "$VMHOST" == 'VIRTUALBOX' ]; then
  echo ''
  echo -e "${CYAN}"'>> Enable VirtualBox guest utilities'"${NC}"
  pacman -S --noconfirm virtualbox-guest-utils xf86-video-vmware
  systemctl enable vboxservice
fi

if [ "$VMHOST" == 'QEMU' ]; then
  echo ''
  echo -e "${CYAN}"'>> Enable QEMU guest agent'"${NC}"
  pacman -S --noconfirm qemu-guest-agent xf86-video-vmware
  systemctl enable qemu-guest-agent
fi