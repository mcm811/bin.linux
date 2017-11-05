#!/bin/sh
sudo mkdir /home/hdd-ext4 /mnt/data-ntfs /mnt/game-ntfs /mnt/win8-ntfs

ln -sf /home/hdd-ext4/kernel ~changmin/.
ln -sf /home/hdd-ext4/linux ~changmin/.
ln -sf /mnt/data-ntfs/torrent ~changmin/.

mkdir ~/changmin/mnt
ln -sf /mnt/* ~/changmin/mnt/.
ln -sf /home/hdd-ext4 ~/changmin/mnt/.
