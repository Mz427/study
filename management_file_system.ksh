#LVS
#ZFS
#FreeBSD/CentOS standard partition(10GB disk).
ada0      10G     GPT
ada0p1    512KB   freebsd-boot
ada0p1    500MB   freebsd-swap
ada0p1    9.5GB   freebsd-zfs

#Mount
mount -t cd9660 -r /dev/cd0a /mnt/cdrom
mount -t msdos /dev/sd2i /mnt/usb1
