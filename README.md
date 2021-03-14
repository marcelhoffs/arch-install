# arch-install

Introduction

Preparation
# Set keyboard layout (optional, if not US international)
loadkeys uk

# Set time
timedatectl set-ntp true

# Partition the drive
fdisk -l
fdisk /dev/sda

# Create 3 partitions, one for boot, one for swap and one for the root
Boot: 300M / type 1
Swap: 4096M / type 82
Root: rest / type 83

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
