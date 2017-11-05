#!/bin/bash

##################################################
# dori-github.sh
# 2012.9.12 <changmin811@gmail.com>
##################################################

alias em='XMODIFIERS= emacs'

export KERNELDIR=`readlink -f .`
export CROSS_COMPILE=$KERNELDIR/android-toolchain-eabi/bin/arm-eabi-

. ~/kernel/dori/dorimanx/arch/arm/configs/dorimanx_defconfig

github_login() {
    git config --global user.name "mcm811"
    git config --global user.email "changmin811@gmail.com"
    git config --global credential.helper cache
    git config --global credential.helper 'cache --timeout=3600'
}

github_sample() {
# Clone your fork (origin)
    git clone https://github.com/gokhanmoral/siyahkernel3.git
# Configure remotes
    cd initramfs3
    git remote add upstream https://github.com/dorimanx/initramfs3.git
    git fetch upstream
# Pull in upstream changes
    git fetch upstream
    git merge upstream/master
# Push commits
    git push origin master
# Create branches
    git branch mybranch
# To switch between branches, use git checkout
    git checkout master
}

siyah_init() {
    ln -s /home/changmin/kernel/dori.sh .
    ln -s linaro-12-android-toolchain android-toolchain

# clone(origin)
    cd ~/kernel/dori
    git clone https://github.com/dorimanx/initramfs3.git initramfs3-dori
    git clone https://github.com/dorimanx/Dorimanx-SG2-I9100-Kernel.git dorimanx

# remote add
    cd ~/kernel/dori/initramfs3-dori
    git remote add dori https://github.com/dorimanx/initramfs3.git
    git remote add voku https://github.com/voku/initramfs3.git
    cd ~/kernel/dori/siyahkernel3
    git remote add dori https://github.com/dorimanx/Dorimanx-SG2-I9100-Kernel.git
    git remote add voku https://github.com/voku/siyahkernel3.git

# fetch, merge
    cd ~/kernel/dori/initramfs3-dori
    git fetch voku
    git merge voku/master
    git fetch dori
    git merge dori/master

    cd ~/kernel/dori/siyahkernel3
    git fetch dori
    git merge dori/master-samsung
    git fetch voku
    git merge voku/master-3.0.y
}

dori_initramfs3_init() {
    cd ~/kernel/dori;mkdir initramfs3;cd initramfs3
    git init .
    git remote add dori https://github.com/dorimanx/initramfs3.git
    git fetch dori
    #git merge dori/master
    git checkout remotes/dori/master
}

dori_kernel_init() {
    cd ~/kernel/dori;mkdir dorimanx;cd dorimanx
    git init .
    git remote add dori https://github.com/dorimanx/Dorimanx-SG2-I9100-Kernel.git
    git fetch dori
    git merge dori/master-jelly-bean
    git checkout remotes/dori/master-jelly-bean
}

siyah_kernel() {
    ~/kernel/dori/dorimanx
    git remote add mcm https://github.com/mcm811/android_kernel_samsung_smdk4210.git
    git fetch mcm
    git cherry-pick 737c7db4c9465a06e083577cd2518ed3e29c6dfb
    git cherry-pick 80510cb18c197816ea7b959655bd33cde8230eae

    git fetch http://review.cyanogenmod.com/CyanogenMod/android_kernel_samsung_aries refs/changes/34/23634/1 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4412 refs/changes/12/20212/5 && git cherry-pick FETCH_HEAD

    em drivers/video/samsung/s3cfb.h drivers/video/samsung/s3cfb_ops.c drivers/video/samsung/s3cfb_main.c drivers/video/fbmem.c
    em drivers/video/fbmem.c
    em drivers/video/samsung/s3cfb.h
    em drivers/video/samsung/s3cfb_ops.c
    em drivers/video/samsung/s3cfb_main.c
    em arch/arm/configs/siyah_defconfig
    em arch/arm/configs/dorimanx_defconfig
# CONFIG_COMPACTION_RETRY is not set
    CONFIG_COMPACTION=y
    CONFIG_MIGRATION=y
    CONFIG_KSM=y
}

siyah_test() {
    cd ~/kernel/dori/siyahkernel3
    cat drivers/video/samsung/s3cfb.h | grep vsync_thread
    cat drivers/video/samsung/s3cfb_main.c | grep vsync_thread
    cat drivers/video/samsung/s3cfb_ops.c | grep s3cfb_vsync_timestamp_changed
    cat arch/arm/configs/dorimanx_defconfig | grep -e KSM -e COMPACTION -e MIGRATION
    cat .config | grep -e KSM -e COMPACTION -e MIGRATION
}

siyah_pkg() {
	# cp cm10-vsync-Siyah-s2-CWM.zip ~/download/cm10-vsync$CONFIG_LOCALVERSION-CWM.zip
	# 7z u ~/download/cm10-vsync$CONFIG_LOCALVERSION-CWM.zip zImage
	# 7z l ~/download/cm10-vsync$CONFIG_LOCALVERSION-CWM.zip
}

siyah_update() {
    cd ~/kernel/dori/siyahkernel3
    git fetch dori
    git fetch voku
    git merge dori/master-samsung
    git merge voku/master-3.0.y
    git grep "<<< HEAD"
}

siyah_build() {
    cd ~/kernel/dori/siyahkernel3
    ./voku_build_kernel.sh
    zip -r ~/download/Dorimanx-$GETVER-SGII-cm10vsync-$(date +%m%d).zip .
    grep CONFIG_LOCALVERSION= arch/arm/configs/dorimanx_defconfig
}

siyah_pkg() {
    GETVER=`grep 'Siyah-Dorimanx-V' ~/kernel/dori/dorimanx/arch/arm/configs/dorimanx_defconfig | cut -c 38-42`
    ZIPPKG=Dorimanx-$GETVER-SGII-cm10vsync-$(date +%m%d).zip
    cp Dorimanx-cm10vsync.zip ~/download/$ZIPPKG
    7z u ~/download/$ZIPPKG zImage
    adb push ~/download/$ZIPPKG /sdcard/Download/
    adb shell su -c "cd /sdcard/Download;. ./kernel_install.sh"
    adb reboot
}

siyah_adb_upgrade() {
    GETVER=`grep 'Siyah-Dorimanx-V' ~/kernel/dori/dorimanx/arch/arm/configs/dorimanx_defconfig | cut -c 38-42`
    adb push ~/download/Dorimanx-$GETVER-SGII-cm10vsync-$(date +%m%d).zip /sdcard/Download/
    adb shell su -c "cd /sdcard/Download;. ./kernel_install.sh;touch /sdcard/.nobootlogo"
    adb reboot
}

main_run() {
    siyah_update
    siyah_build
    siyah_pkg
    siyah_adb_upgrade
}

main_run

em sound/soc/codecs/mc1n2/mc1n2_cfg.h
em ~/kernel/dori/initramfs3/sbin/init


em drivers/video/samsung/s3cfb_main.c

mount /dev/block/mmcblk0p9 /system/;mkdir /sdcard;mount /dev/block/mmcblk0p11 /sdcard
adb shell "mount /dev/block/mmcblk0p9 /system/;mkdir /sdcard;mount /dev/block/mmcblk0p11 /sdcard"

em ~/kernel/dori/dorimanx/arch/arm/configs/dorimanx_defconfig
em ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/arch/arm/configs/siyah_defconfig

# backup
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/blk* ~/workspace/blk_siyah/
cp ~/kernel/dori/dorimanx/include/linux/blk* ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/

# block
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/bio.h ~/workspace/blk_siyah/
cp ~/kernel/dori/dorimanx/include/linux/bio.h ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/

rm *patch;git format-patch 0af24eb816456fee5ed8576820f084f5ae6b0ce2..5cc1ecc62a02c5919f28c35815e4e555523dbca6
