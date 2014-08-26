#!/bin/bash

tune2fs -o journal_data_writeback /dev/sda2
mount -o remount,discard,noatime,nodiratime,barrier=0,nobh,commit=60 -t ext4 /dev/sda3 /

tune2fs -o journal_data_writeback /dev/sda3
mount -o remount,discard,noatime,nodiratime,barrier=0,nobh,commit=60 -t ext4 /dev/sda2 /mnt/android-ext4-ssd

tune2fs -o journal_data_writeback /dev/sdb2
mount -o remount,noatime,nodiratime,barrier=0,nobh,commit=60 -t ext4 /dev/sdb2 /mnt/data-ext4-hdd 
