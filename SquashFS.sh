#!/bin/bash
# installs kpartx and squashfs-tools
sudo apt-get install kpartx squashfs-tools
#
# This opens your image file. 
#Change the DownloadedImage.img to what your image file name is.
sudo kpartx -av DownloadedImage.img
#
# After opening the image it will give you at least two /dev/mapper/loop#p#.  
# You want the bigger of the partitions (Normally p2).  
# In this case it was loop 1 is the image and I want partition 2 because it is the bigger of the two.
# sudo mount /dev/mapper/loop1p2 /mnt
# Change # to the loop number the previous command reported.
#
sudo mount /dev/mapper/loop#p2 /mnt
#
# This is what make the image writable on berryboot
# This line should work as is.  It edits the file fstab on the image folder etc
sudo sed -i 's/^\/dev\/mmcblk/#\0/g' /mnt/etc/fstab
#
# This line is what takes the mounted image and converts it the a squashfs image.
# Note if you do this from the raspberry pi it will take several hours (dependent on the original image size).
# Change NewBerryBoot.img to the desired image name.
sudo mksquashfs /mnt NewBerryBoot.img -comp lzo -e lib/modules
#
# This unmounts the image you mounted at the beginning.
# This line should work as is
sudo umount /mnt
#
# This closes the image we opened at the beginning.
# Change the DownloadedImage.img to what your image file name is.
sudo kpartx -d DownloadedImage.img



#-------------------Crankshaft SquashFS

$ sudo kpartx -av crankshaft.img 
#Loop which ever Loop is larger
$ sudo mount /dev/mapper/loop0p2 /mnt

$ sudo sed -i 's/^\/dev\/mmcblk/#\0/g' /mnt/etc/fstab

$ sudo sed -i 's/^PARTUUID/#\0/g' /mnt/etc/fstab

$ sudo rm -f /mnt/etc/console-setup/cached_UTF-8_del.kmap.gz

$ sudo rm -f /mnt/etc/systemd/system/multi-user.target.wants/apply_noobs_os_config.service

$ sudo rm -f /mnt/etc/systemd/system/multi-user.target.wants/raspberrypi-net-mods.service

$ sudo rm -f /mnt/etc/rc3.d/S01resize2fs_once

$ sudo mksquashfs /mnt crankshaftBB.img -comp lzo -e lib/modules

$ sudo umount /mnt

$ sudo kpartx -d crankshaft.img
