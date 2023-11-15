# m1lkie-arch
My Arch installation for future use

## Installation

- Check if you are on UEFI, should return 64

```
cat /sys/firmware/efi/fw_platform_size
```

- Connect to a network
- Check that the time is right by running `timedatectl`
- Update mirrorlist by running `update-mirrorlist.sh` #TODO
- Partition the disks accordingly using `fdisk -l` to list devices
- Using `fdisk /dev/mydevice' create:
    - 500M for the boot partition
    - The rest for root partition

- Format the boot partition

```
mkfs.fat -F32 /dev/mydevice1
```

- Setup the encrypted root partition

```
cryptsetup -y -v luksFormat /dev/mydevice2
cryptdetup open /dev/mydevice2 cryptroot
mkfs.ext4 /dev/mapper/cryptroot
```

- Mount the partitions

```
mount /dev/mapper/cryptroot /mnt
mount --mkdir /dev/mydevice1 /mnt/boot
```

- Install the base system onto the root partition

```
pacstrap /mnt base linux linux-firmware vim neovim amd-ucode
```

- Generate fstab file

```
genfstab -U /mnt >> /mnt/etc/fstab
```

- Chroot into the new system

```
arch-chroot /mnt
```

- Create the swapfile

```
fallocate -l 10GB /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

- Update fstab with the swapfile information

```
/etc/fstab:
---

# /swapfile
/swapfile none swap defaults 0 0
```

- Configure localtime and hwclock

```
ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/locatime
hwclock --systohc
```

- Edit the `/etc/locale.gen` file and uncomment 'en_US.UTF-8 UTF-8'
- Then run `locale-gen`

```
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
```

- Set hostname and update hosts file

```
echo yourhostname >> /etc/hostname
```

```
/etc/hosts:
---

127.0.0.1  localhost
::1        localhost
127.0.1.1  yourhostname.localdomain  yourhostname
```

- Set the root password

```
passwd
```

- Install all the necessary packages by running `install-packages.sh` #TODO
- Edit the `/etc/mkinitcpio.conf` 'HOOKS' variable by adding 'encrypt' after block and run mkinitcpio

```
mkinitcpio -p linux
```

- Install the bootloader

```
efivar --list
bootctl install
cd /boot/loader
```

- Edit the 'loader.conf' file

```
loader.conf:
---

default arch.conf
timeout 2
console-mode max
editor no
```

- Create a file called `/boot/loader/entries/arch.conf` and add this

```
arch.conf:
---

title Arch Linux
linux /vmlinuz-linux
initrd  /amd-ucode.img
initrd /initramfs-linux.img
options nvme_load=YES rw cryptdevice=UUID=partitionuuid:cryptroot root=/dev/mapper/cryptroot rw
```

- To get the UUID you can run this to find it

```
ls -l /dev/disk/by-uuid
ls /dev/disk/by-uuid | grep 'XXX' >> /boot/loader/entries/arch.conf
```

- But replace 'XXX' with the first few characters of the partition you want to use
- Enable necessary services so that they start right away after reboot

```
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
```

- Add a user

```
useradd -mG wheel yourusername
password yourusername
```

- Set sudo permissions

```
EDITOR=nvim visudo
```

- And then uncomment 'wheel ALL ALL'
- Reboot the system
