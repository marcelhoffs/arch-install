# arch-install

# Introduction
This repository provides an easy way to install Arch Linux on an UEFI based PC. There are some hard coded things in this script. These are easily changed if needed (see scripts in library directory).
- The locale will be set to en_US.UTF-8
- The timezone will be set to Europe\Brussels
- Pacman mirrors are optimized for Belgium\Netherlands\France\Germany

Make sure that you have a working internet connection. This can be via ethernet or wifi. If you want to use wifi you can connect to the intenet via:
```
iwctl station wlan0 connect <SSID>
```

# Step 1: Preparation
You must first run the preparation script. This script creates the needed partitions and formats them.
It will also mount the partitions and prepares them for further installation

The script creates the following partitions for an UEFI system.
Partition | Size | Type | Mount
--------- | ---- | ---- | -----
Boot | 500M | EFI (ef) | /mnt/boot
Swap | 4G | Linux Swap (82) | swap
Root | rest | Linux (83) | /mnt

**Download and execute the script**
```
curl -o prep.sh https://raw.githubusercontent.com/marcelhoffs/arch-install/main/prep.sh
or alternatively
curl -o prep.sh -L https://tinyurl.com/arch-install-prep

chmod +x prep.sh
./prep.sh
```

# Step 2: Run the base installer
```
cd /arch-install
./base.sh
```
The base.sh script will do the following:
- Set hostname and create hosts file
- Set timezone to Europe/Brussels
- Install Linux kernel
- Install base packages
- Install Intel or AMD CPU Microcode
- Update pacman mirror list (Belgium\Netherlands\France\Germany)
- Set locale (en_US.UTF-8)
- Install the bootloader (systemd-boot)
- Install packages for virtual guest
- Update all packages
- Enable services
- Set root password
- Create user
- Move installation files to the user directory

# Step 3: Install GNOME Desktop Environment
If you are using wifi, then after reboot, you will not have an internet connection anymore. You can connect to your wifi by using:
```
nmtui
```

Now, after reboot you will find the arch-install folder in the users home directory.
From there you can start the installer for the GNOME Desktop Environment. Run the script as a regular user.
```
cd arch-install
./gnomedesktop.sh
```
---
<sub>Wallpapers courtesy of the Vanilla OS project: https://github.com/Vanilla-OS</sub>

# Other things
## Install printer
Install a printer with the everywhere driver
```
sudo lpadmin -p "MFC-J5930DW" -E -v ipp://brother.rdbx.be:631 -m everywhere
```