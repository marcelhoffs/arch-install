# arch-install

# Introduction
This repository provides an easy way to install Arch Linux on an UEFI system.

# Preparation
You should first partition the drives manually. After that you can use the scripts to do a base installation and install a desktop environment of choice.

The script expect the following partitions:
Partition | Size | Type | Mount
--------- | ---- | ---- | -----
Boot | 300M | EFI (1) | /mnt/boot/EFI
Swap | 4096M | Linux Swap (82) | swap
Root | rest | Linux (83) | /mnt

```
# Set time
timedatectl set-ntp true

# Partition the drive
fdisk -l
fdisk /dev/sda

# Delete all existing partitions
d

# Create EFI partition
n
p
1
default first sector
+300M
t
1
w

# Create filesystem for root
n
p
2
default first sector
default last sector
w

# Format EFI partition
mkfs.fat -F32 /dev/sda1

# Set swap partition
mkswap /dev/sda2
swapon /dev/sda2

# Format root partition
mkfs.ext4 /dev/sda3

# Mount drives (root first)
mount /dev/sda3 /mnt
mkdir -p /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI

# Install base system 
pacstrap -i /mnt base base-devel vi nano git 

# Generate fstab
genfstab -U -p /mnt >> /mnt/etc/fstab

# Chroot
arch-chroot /mnt
```