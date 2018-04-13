#!/bin/bash

adb_mount_fs()
{
    local FSTYPE=$1
    local DEVICE=$2
    local MNTDIR=$3
    local ADBCMD="[ -d $MNTDIR ] && ((df|grep $MNTDIR) > /dev/null 2>&1 || mount -t $FSTYPE $DEVICE $MNTDIR)"
    # echo $ADBCMD
    adb shell su -c "$ADBCMD"
    return $?
}

adb_wipe_dalvik_cache()
{
    adb_mount_fs ext4 /dev/block/mmcblk0p7  /cache
    adb_mount_fs ext4 /dev/block/mmcblk0p10 /data
    adb shell "rm /data/dalvik-cache/*"
    adb shell "rm /cache/dalvik-cache/*"
}

get_dir()
{
    local DIR0=/sdcard/$1;
    local DIR1=/emmc/$1;
    local DIR2=/storage/sdcard1/$1;
    DIR=$(adb shell "\
		([ -d $DIR0 ] && echo -n $DIR0) || \
		([ -d $DIR1 ] && echo -n $DIR1) || \
		([ -d $DIR2 ] && echo -n $DIR2)")
    test ! -z "$DIR"
    return $?
}

get_phone()
{
    local DIR="A"
    local DIR0=/storage/sdcard0/$DIR;
    local DIR1=/storage/sdcard1/$DIR;
    local DIR2=/emmc/$DIR;
    local DIR3=/sdcard/$DIR;
    eval 'TARGET= $(\
		([ -d $DIR0 ] && echo -n $DIR0) || \
		([ -d $DIR1 ] && echo -n $DIR1) || \
		([ -d $DIR2 ] && echo -n $DIR2) || \
		([ -d $DIR3 ] && echo -n $DIR3))'
    test ! -z "$TARGET"
    return $?
}

push_file()
{
    if get_dir "Download"; then
	#echo "adbpush $(basename $1) $DIR"
	echo "adbpush $(basename $1)"
	adb push $1 $DIR
    else
	adb_mount_fs vfat /dev/block/mmcblk0p11 /storage/sdcard0
	adb_mount_fs vfat /dev/block/mmcblk0p11 /emmc
	adb_mount_fs vfat /dev/block/mmcblk1p1 /storage/sdcard1
	adb_mount_fs vfat /dev/block/mmcblk1p1 /sdcard
	get_dir "Download" && adb push $1 $DIR
    fi
    return $?
}

rcmount
push_file $1
