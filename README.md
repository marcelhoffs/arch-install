# arch-install

# Introduction
This repository provides an easy way to install Arch Linux on an UEFI or BIOS system. There are some hard coded things in this script. These are easily changed if needed (see scripts in library directory).
- The locale will be set to en_US.UTF-8
- The timezone will be set to Europe\Brussels
- Pacman mirrors are optimized for Belgium\Netherlands\Germany

# Step 1: Preparation
You should first partition the drives manually. After that you can use the scripts to do a base installation and install a desktop environment of choice.

The script expect the following partitions for an UEFI system. For BIOS you can ignore the boot partition:
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
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
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

# Step 2: Clone the repository and run the base installer
```
mkdir /arch-install
cd /arch-install
git clone https://github.com/marcelhoffs/arch-install .
chmod +x base.sh
./base.sh
```
The base.sh script will do the following:
- Set hostname and hosts file
- Set timezone to Europe/Brussels
- Install the selected kernel
- Install base packages
- Install Intel or AMD CPU Microcode
- Update pacman mirror list (Netherlands/Belgium/Germany)
- Set locale (en_US.UTF-8)
- Install GRUB bootloader
- Install packages for virtual guest
- Update all packages
- Enable services
- Set root password
- Create user
- Move installation files to the user directory

# Step 3: Install Desktop Environment
After reboot you will find the arch-install folder in the users home directory.
From there you can start the installer for Desktop Environments. Run the script with root privileges.
```
cd arch-install
sudo ./desktop.sh
```