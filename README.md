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

**1. First set the time**
```
timedatectl set-ntp true
```

**2. Partition the drive**
```
# Partition the drive
fdisk -l
fdisk /dev/sda

# Create EFI partition
n
p
1
default first sector
+300M
t
1

# Create Swap partition
n
p
2
default first sector
+4096M
t
82
w

# Create filesystem for root
n
p
2
default first sector
default last sector
w
```

**3. Format the drive**
```
# Format EFI partition
mkfs.fat -F32 /dev/sda1

# Set swap partition
mkswap /dev/sda2
swapon /dev/sda2

# Format root partition
mkfs.ext4 /dev/sda3
```

**4. Mount the drives**
```
mount /dev/sda3 /mnt
mkdir -p /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI
```

**5. Install base the base system**
```
pacstrap -i /mnt base base-devel vi nano git 
```

**6. Generate fstab**
```
genfstab -U -p /mnt >> /mnt/etc/fstab
```

**7. Change root**
```
arch-chroot /mnt
```

**8. Clone the repository and run the base installer**
```
mkdir /arch-install
cd /arch-install
git clone https://github.com/marcelhoffs/arch-install .
./base.sh
```