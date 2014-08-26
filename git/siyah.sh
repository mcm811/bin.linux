#!/bin/bash
##################################################
# siyah-github.sh
# 2012.9.12 <changmin811@gmail.com>
##################################################

alias em='XMODIFIERS= emacs'

export KERNELDIR=`readlink -f .`
export CROSS_COMPILE=$KERNELDIR/android-toolchain-eabi/bin/arm-eabi-

export ARCH=arm
export EXTRA_AFLAGS=-mfpu=neon
export USE_SEC_FIPS_MODE=true

. ~/kernel/siyah/siyahkernel3/arch/arm/configs/siyah_defconfig

git_login_setup()
{
    git config --global user.name "mcm811"
    git config --global user.email "changmin811@gmail.com"
    git config --global credential.helper cache
    git config --global credential.helper 'cache --timeout=3600'
}


git_linux() {
    git clone https://github.com/torvalds/linux.git

    git fetch
    git merge remotes/origin/master

    git pull https://github.com/torvalds/linux.git
}

github_sample()
{
# Clone your fork
    git clone https://github.com/gokhanmoral/siyahkernel3.git

# Configure remotes
    git remote --help
    git remote rename <old> <new>

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

siyah_init()
{
    cd ~/kernel/siyah
    #git clone https://github.com/gokhanmoral/initramfs3.git
    mkdir initramfs3
    cd initramfs3
    git init
    git remote add upstream https://github.com/gokhanmoral/initramfs3.git
    git fetch upstream
    git merge upstream/master
    cd ..

    #git clone https://github.com/gokhanmoral/siyahkernel3.git
    mkdir siyahkernel3
    cd siyahkernel3
    git init
    git remote add upstream https://github.com/gokhanmoral/siyahkernel3.git
    git remote set-branches upstream master-3.0.31

    git fetch upstream
    git merge upstream/master-3.0.31
}

siyah_initramfs()
{
    cd ~/kernel/siyah/initramfs3
    cat <<EOF >> sbin/ext/tweaks.sh
# fix crt effect
setprop debug.sf.electron_frames 29
EOF
    em ~/kernel/siyah/initramfs3/sbin/ext/tweaks.sh
}

siyah_kernel()
{
    cd ~/kernel/siyah/siyahkernel3
    git remote add mcm811 https://github.com/mcm811/android_kernel_samsung_smdk4210.git
    git fetch mcm811
    repo cherry-pick 737c7db4c9465a06e083577cd2518ed3e29c6dfb
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_kernel_samsung_aries refs/changes/34/23634/1 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4412 refs/changes/12/20212/5 && git cherry-pick FETCH_HEAD
    em drivers/video/samsung/s3cfb.h drivers/video/samsung/s3cfb_ops.c drivers/video/samsung/s3cfb_main.c
    em drivers/video/fbmem.c
    em drivers/video/samsung/s3cfb.h
    em drivers/video/samsung/s3cfb_ops.c
    em drivers/video/samsung/s3cfb_main.c
    grep -e "vsync_time" drivers/video/samsung/s3cfb_main.c

    em arch/arm/configs/siyah_s2_defconfig
    em arch/arm/configs/siyah_defconfig
# CONFIG_COMPACTION_RETRY is not set
    CONFIG_COMPACTION=y
    CONFIG_MIGRATION=y
    CONFIG_KSM=y

    CONFIG_FB_S5P_VSYNC_THREAD=y
    CONFIG_ION=y
    CONFIG_ION_EXYNOS=y
    #CONFIG_ION_EXYNOS_CONTIGHEAP_SIZE=71680
    CONFIG_ION_EXYNOS_CONTIGHEAP_SIZE=45056
}

siyah_test()
{
    cd ~/kernel/siyah/siyahkernel3
    cat drivers/video/samsung/s3cfb.h | grep vsync_thread
    cat drivers/video/samsung/s3cfb_main.c | grep vsync_thread
    cat drivers/video/samsung/s3cfb_ops.c | grep s3cfb_vsync_timestamp_changed
    cat .config | grep -e KSM -e COMPACTION -e MIGRATION
}

siyah_update()
{
    cd ../initramfs3
    git fetch upstream
    git merge upstream/master

    cd ../siyahkernel3
    git fetch upstream
    git merge upstream/master-3.0.31

    git rebase upstream/master-3.0.31
    git add -A && git rebase --continue

    git format-patch upstream/master-3.0.31
    git reset --hard upstream/master-3.0.31
}

siyah_build()
{
    cd ~/kernel/siyah/siyahkernel3
    ./build_kernel.sh
}

siyah_pkg()
{
    . ~/kernel/siyah/siyahkernel3/arch/arm/configs/siyah_defconfig
    ZIPPKG=${CONFIG_LOCALVERSION##-}-cm10vsync-$(date +%m%d).zip
	cp Siyah-cm10vsync.zip ~/download/$ZIPPKG
	7z u ~/download/$ZIPPKG zImage
	adb push ~/download/$ZIPPKG /sdcard/Download/
	adb shell su -c "cd /sdcard/Download;. ./kernel_install.sh"
	adb reboot
}

siyah_adb_upgrade()
{
    . ~/kernel/siyah/siyahkernel3/arch/arm/configs/siyah_defconfig
    adb push ~/download/${CONFIG_LOCALVERSION##-}-cm10vsync.zip /sdcard/Download/
    adb shell su -c "cd /sdcard/Download;. ./kernel_install.sh"
    adb reboot
}

main_run() {
    siyah_update
    siyah_build
    siyah_pkg
    siyah_adb_upgrade
}

main_run

siyaho_todo()
{
#kernel
    cd drivers/video/samsung
    em drivers/video/fbmem.c
    em drivers/video/samsung/s3cfb.h
    em drivers/video/samsung/s3cfb_main.c
    em drivers/video/samsung/s3cfb_ops.c

#rom
    em ~/android/system/hardware/samsung/exynos4/hal/include/s3c_lcd.h
    em ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/Android.mk
    em ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp
    em ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWCUtils.h
}

mali_touchboost()
{
# drivers/input/keyboard/cypress/cypress-touchkey.c:extern void gpu_boost_on_touch(void);
# drivers/input/keyboard/cypress/cypress-touchkey.c:              gpu_boost_on_touch();
# drivers/input/keyboard/gpio_keys.c:void gpu_boost_on_touch(void);
# drivers/input/keyboard/gpio_keys.c:             if(!!state) gpu_boost_on_touch();
# drivers/input/touchscreen/mxt224_u1.c:extern void gpu_boost_on_touch(void);
# drivers/input/touchscreen/mxt224_u1.c:                  gpu_boost_on_touch();
# drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c:void gpu_boost_on_touch(void)
}

du -sh --exclude='out*'

jb_mali()
{
    em arch/arm/configs/siyah_s2_defconfig

    cd drivers/media/video/samsung/mali/common_siyah
    cd drivers/media/video/samsung/mali/linux_siyah

    em drivers/media/video/samsung/mali/common/gpu_voltage_control.c
    em drivers/media/video/samsung/mali/linux/mali_kernel_pm.c

    git fetch http://review.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4210 refs/changes/80/23580/7 && git cherry-pick FETCH_HEAD

    diff -uw arch/arm/configs/siyah_defconfig ~/android/system/kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
    cp ~/android/system/kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig arch/arm/configs/

    em arch/arm/configs/cyanogenmod_i9100_defconfig
    em arch/arm/configs/siyah_s2_defconfig
}

mali_config()
{
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y

CONFIG_SYNC=y
# CONFIG_SW_SYNC is not set
# CONFIG_SW_SYNC_USER is not set

# 2096
CONFIG_ION=y
CONFIG_ION_EXYNOS=y
CONFIG_ION_EXYNOS_CONTIGHEAP_SIZE=71680

# CONFIG_SW_SYNC is not set
# CONFIG_SW_SYNC_USER is not set

# CONFIG_ION is not set
# CONFIG_ION_EXYNOS is not set
# CONFIG_ION_EXYNOS_CONTIGHEAP_SIZE is not set

CONFIG_VIDEOBUF2_ION=y
# CONFIG_VIDEOBUF2_ION is not set
}

#CONFIG_FB_S5P_NR_BUFFERS=2
CONFIG_FB_S5P_NR_BUFFERS=3

em arch/arm/mach-exynos/mach-u1.c
em arch/arm/mach-exynos/mach-px.c
em drivers/video/s3c-fb.c
em include/linux/ion.h

CONFIG_S5P_MEM_CMA=y
# CONFIG_S5P_MEM_CMA is not set

CONFIG_CMA=y
# CONFIG_CMA_DEVELOPEMENT is not set
CONFIG_CMA_BEST_FIT=y

# CONFIG_CMA is not set
# CONFIG_CMA_DEVELOPEMENT is not set
# CONFIG_CMA_BEST_FIT is not set

CONFIG_VIDEOBUF2_CMA_PHYS=y
# CONFIG_VIDEOBUF2_CMA_PHYS is not set

DIFFPATH=
SMDKPATH=/home/changmin/android/system_jbmali/kernel/samsung/smdk4210/$DIFFPATH
SIYAHPATH=/home/changmin/kernel/siyah/siyahkernel3-jbmali/$DIFFPATH
diff -urw $SMDKPATH $SIYAHPATH > ~/gpu.diff

mc1n2_cfg()
{
    sj;cd sound/soc/codecs/mc1n2;
    em sound/soc/codecs/mc1n2/mc1n2_cfg.h
    cp sound/soc/codecs/mc1n2/mc1n2_cfg.h sound/soc/codecs/mc1n2/mc1n2_cfg.h.bak
    cp ~/workspace/mc1n2_cfg.h-24bit sound/soc/codecs/mc1n2/mc1n2_cfg.h

    #MCDRV_BITSEL_16,
    MCDRV_BITSEL_24,

    #MCDRV_BCKFS_32,
    MCDRV_BCKFS_512,

    #MCDRV_FS_44100,
    MCDRV_FS_48000,
}

em drivers/video/samsung/s3cfb.h

em arch/arm/configs/dorimanx_defconfig
e arch/arm/configs/siyah_defconfig
em drivers/media/video/samsung/mali_r2p3/Makefile
em drivers/media/video/samsung/mali_r3p0/Makefile
em drivers/media/video/samsung/mali/Makefile
CONFIG_MALI_MEM_SIZE ?= 512
#CONFIG_MALI_MEM_SIZE ?= 64

git grep CONFIG_MALI_MEM_SIZE

em arch/arm/configs/cyanogenmod_i9100_defconfig
em arch/arm/configs/siyah_defconfig
CONFIG_TARGET_LOCALE_KOR=y

em arch/arm/configs/u1_kor_kt_defconfig
em arch/arm/configs/u1_kor_skt_defconfig
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_TDMB=y
CONFIG_TDMB_SPI=y
CONFIG_TDMB_VENDOR_INC=y
CONFIG_TDMB_T3900=y
CONFIG_TDMB_VENDOR_TELECHIPS=y
CONFIG_TDMB_TCC3170=y

em drivers/video/samsung/mdnie.h
//#if defined(CONFIG_TARGET_LOCALE_KOR) || defined(CONFIG_TARGET_LOCALE_NTT)
enum SCENARIO_DMB {
	DMB_NORMAL_MODE = 20,
	DMB_WARM_MODE,
	DMB_COLD_MODE,
	DMB_MODE_MAX,
};
//#endif

# boot progress
em drivers/video/samsung/Makefile
obj-$(CONFIG_FB_S5P_LD9040)	+= ld9040.o smart_dimming_ld9042.o boot_progressbar.o

em drivers/video/samsung/s3cfb_main.c
#if defined(CONFIG_MACH_U1_BD) && defined(CONFIG_TARGET_LOCALE_EUR)

setprop wifi.supplicant_scan_interval 300

# CONFIG_FB_S5P_SYSMMU is not set
CONFIG_FB_S5P_SYSMMU=y

em kernel/power/wakelock.c
# 604
//suspend_work_queue = alloc_workqueue("suspend", WQ_HIGHPRI, 0);
suspend_work_queue = alloc_workqueue("suspend", WQ_UNBOUND|WQ_HIGHPRI, 0);

# 313 grep -E "^[0-9]+"
em drivers/media/video/samsung/mali_r3p0/Makefile
#SVN_REV:=$(shell ((svnversion | grep -qv exported && echo -n 'Revision: ' && svnversion) || git svn info | sed -e 's/$$$$/M/' | grep '^Revision: ' || echo ${MALI_RELEASE_NAME}) 2>/dev/null | sed -e 's/^Revision: //')
SVN_REV:=$(shell ((svnversion | grep -E "^[0-9]+" && echo -n 'Revision: ' && svnversion) || git svn info | sed -e 's/$$$$/M/' | grep '^Revision: ' || echo ${MALI_RELEASE_NAME}) 2>/dev/null | sed -e 's/^Revision: //')
# 323
em drivers/media/video/samsung/mali/Makefile
# 17
em drivers/media/video/samsung/ump/Makefile.common
# 89
em drivers/media/video/samsung/ump/Makefile

##########################################################################################
em arch/arm/mach-exynos/stand-hotplug.c
em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform_dvfs.c
##########################################################################################
em drivers/media/video/samsung/mali/common/mali_kernel_utilization.c
em drivers/media/video/samsung/mali/platform/mali_platform.h
em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c
em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform_dvfs.c
##########################################################################################

/home/changmin/android/system_jbmali/kernel/samsung/smdk4210-1013-3.0.45

#ARM: SMP: use a timing out completion for cpu hotplug
em arch/arm/kernel/smp.c
#61
static DECLARE_COMPLETION(cpu_running);
#126
wait_for_completion_timeout(&cpu_running, msecs_to_jiffies(1000));
#328
complete(&cpu_running);

em sound/soc/codecs/mc1n2/mc1n2_cfg.h
em ./vendor/samsung/galaxys2-common/proprietary/system/usr/share/alsa/alsa.conf
em ./device/samsung/galaxys2-common/configs/asound.conf
                format S16_LE
                rate 44100

#vsync_off
em arch/arm/configs/siyah_defconfig
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
# CONFIG_SYNC is not set
# CONFIG_SW_SYNC is not set
# CONFIG_SW_SYNC_USER is not set
CONFIG_FB_S5P_VSYNC_THREAD=y
# CONFIG_FB_S5P_VSYNC_THREAD is not set

em drivers/video/samsung/s3cfb.h
em drivers/video/samsung/s3cfb_main.c
em drivers/video/samsung/s3cfb_ops.c

#ENABLE for POWERTOP
em arch/arm/configs/siyah_defconfig
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
CONFIG_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y

# cm10
em system/core/rootdir/init.rc
# siyah
em res/misc/init.cm10/init.rc
export TERMINFO /system/etc/terminfo
export TERM=linux


em kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
# vsync_sysfs
sed -i \
    -e 's/#define USE_VSYNC_MODE USE_VSYNC_OFF/#define USE_VSYNC_MODE USE_VSYNC_SYSFS/g' \
    kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c

sed -i \
    -e 's/# CONFIG_SYNC is not set/CONFIG_SYNC=y/g' \
    -e 's/# CONFIG_SW_SYNC is not set/CONFIG_SW_SYNC=y/g' \
    -e 's/# CONFIG_SW_SYNC_USER is not set/CONFIG_SW_SYNC_USER=y/g' \
    kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig

# vsync_off
sed -i \
    -e 's/#define USE_VSYNC_MODE USE_VSYNC_SYSFS/#define USE_VSYNC_MODE USE_VSYNC_OFF/g' \
    kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c

sed -i \
    -e 's/CONFIG_SYNC=y/# CONFIG_SYNC is not set/g' \
    -e 's/CONFIG_SW_SYNC=y/# CONFIG_SW_SYNC is not set/g' \
    -e 's/CONFIG_SW_SYNC_USER=y/# CONFIG_SW_SYNC_USER is not set/g' \
    kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig

###########################################################################################
# samsung_modemctl: fix crash on gcc 4.6
#
# In gcc 4.3, when one declares an array with size 0, one block of
# memory is assigned making the code work. This is no longer the
# case with gcc 4.6.
#
# Change-Id: Ie4d04d4b55c768af6c088f4a1bd4fa294c2b598

# 217
em drivers/phone_svn/svnet/sipc4.c
unsigned long pdp_bitmap[PDP_MAX/BITS_PER_LONG];
unsigned long pdp_bitmap[DIV_ROUND_UP(PDP_MAX, BITS_PER_LONG)];

git fetch http://review.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4210 refs/changes/30/25030/1 && git cherry-pick FETCH_HEAD

git format-patch 3bf9245859cda5b76783907881848e1594263ce0..0baae403fdd1cc3f7fdf298e8c67aa5b7ca0faad

mount /dev/block/mmcblk0p9 /system/;mkdir /sdcard;mount /dev/block/mmcblk0p11 /sdcard
adb shell "mount /dev/block/mmcblk0p9 /system/;mkdir /sdcard;mount /dev/block/mmcblk0p11 /sdcard"

em ~/kernel/dori/dorimanx/arch/arm/configs/dorimanx_defconfig
em ~/kernel/siyah/siyahkernel3/arch/arm/configs/siyah_defconfig

# backup
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/fs/bio.c ~/workspace/blk_siyah/
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/kernel/fork.c ~/workspace/blk_siyah/
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/blk* ~/workspace/blk_siyah/
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/bio.h ~/workspace/blk_siyah/
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/elevator.h ~/workspace/blk_siyah/
cp ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/iocontext.h ~/workspace/blk_siyah/

# restore
cp ~/workspace/blk_siyah/bio.c	 	~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/fs/bio.c			 
cp ~/workspace/blk_siyah/fork.c	 	~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/kernel/fork.c			 
cp ~/workspace/blk_siyah/blk*	 	~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/		 
cp ~/workspace/blk_siyah/bio.h	 	~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/bio.h		 
cp ~/workspace/blk_siyah/elevator.h	~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/elevator.h	 
cp ~/workspace/blk_siyah/iocontext.h	~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/iocontext.h	 

# block
cp ~/kernel/dori/dorimanx/fs/bio.c ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/fs/
cp ~/kernel/dori/dorimanx/kernel/fork.c ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/kernel/
cp ~/kernel/dori/dorimanx/include/linux/blk* ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/
cp ~/kernel/dori/dorimanx/include/linux/bio.h ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/
cp ~/kernel/dori/dorimanx/include/linux/elevator.h ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/
cp ~/kernel/dori/dorimanx/include/linux/iocontext.h ~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/include/linux/


# tar backup
tar cvzf backup/siyahkernel3-jbmali-vsync_sysfs-1017.tgz --exclude=*.o siyahkernel3-jbmali-vsync_sysfs

rm *.patch
git format-patch 5e859263def600b59dcae0bcbf3ef18b5ec22d18..0af24eb816456fee5ed8576820f084f5ae6b0ce2



cp 0001-Trying-to-FIX-CRT-anim-when-screen-is-OFF-and-WIFI-O.patch 0013-CRT-Anim-Reports-that-lockscreen-is-blick-for-0.2sec.patch ~/workspace/crtoff/
git am ~/workspace/crtoff/*.patch

em kernel/power/fbearlysuspend.c

# Trying to FIX CRT anim when screen is OFF and WIFI OFF (dorimanx)
https://github.com/dorimanx/Dorimanx-SG2-I9100-Kernel/commit/fee38058a257f1bdc98797f498a7cd2344af4f41
# CRT Anim, Reports that lockscreen is blick for 0.2sec after screen off. (dorimanx)
https://github.com/dorimanx/Dorimanx-SG2-I9100-Kernel/commit/0af24eb816456fee5ed8576820f084f5ae6b0ce2

em arch/arm/configs/siyah_defconfig

./include/config/iosched/fiops.h
./block/fiops-iosched.c

git am ~/kernel/dori/dorimanx/*patch


vsync_off()
{
    cd /home/changmin/kernel/siyah/siyahkernel3-jbmali-vsync_off
    sed -i \
	-e 's/#define USE_VSYNC_MODE USE_VSYNC_SYSFS/#define USE_VSYNC_MODE USE_VSYNC_OFF/g' \
	drivers/video/samsung/s3cfb_main.c

    em drivers/video/samsung/s3cfb_main.c

    sed -i \
	-e 's/CONFIG_LOCALVERSION\=.*/CONFIG_LOCALVERSION\=\"-Siyah-s2-v4.1.5-cm10-jbmali\"/g' \
	-e 's/CONFIG_SYNC=y.*/# CONFIG_SYNC is not set/g' \
	-e 's/CONFIG_SW_SYNC=y.*/# CONFIG_SW_SYNC is not set/g' \
	-e 's/CONFIG_SW_SYNC_USER=y.*/# CONFIG_SW_SYNC_USER is not set/g' \
	arch/arm/configs/siyah_defconfig

    em arch/arm/configs/siyah_defconfig

    sed -i \
	-e 's/INITRAMFS_TMP\=.*/INITRAMFS_TMP\=\"\/tmp\/initramfs\-source\-jbmali\-vsync\_off\"/g' \
	build_kernel.sh
}

diff \
/home/changmin/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/drivers/video/samsung/s3cfb_main.c \
/home/changmin/kernel/s5/siyahkernel3/drivers/video/samsung/s3cfb_main.c

diff \
/home/changmin/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/arch/arm/configs/siyah_defconfig \
/home/changmin/kernel/s5/siyahkernel3/arch/arm/configs/siyah_s2_defconfig

drivers/media/video/samsung/mali/platform/pegasus-m400/mali_platform.c:void gpu_boost_on_touch(void)
drivers/media/video/samsung/mali_r3p0_lsi/common/mali_osk.h:#define gpu_boost_on_touch new_gpu_boost_on_touch

# recovery mount
adb shell "mount /dev/block/mmcblk0p9 /system/;mkdir /sdcard;mount /dev/block/mmcblk0p11 /sdcard"

git revert HEAD
git reset --hard 94e004c51bc8fb593c1df22db10774f1f18d86a0
git revert 94e004c51bc8fb593c1df22db10774f1f18d86a0

git grep gpu_boost_on_touch

drivers/input/keyboard/cypress/cypress-touchkey.c:extern void gpu_boost_on_touch(void);
drivers/input/keyboard/cypress/cypress-touchkey.c:              gpu_boost_on_touch();
drivers/input/keyboard/gpio_keys.c:void gpu_boost_on_touch(void);
drivers/input/keyboard/gpio_keys.c:                     gpu_boost_on_touch();
drivers/input/touchscreen/mxt224_u1.c:extern void gpu_boost_on_touch(void);
drivers/input/touchscreen/mxt224_u1.c:                  gpu_boost_on_touch();
drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c:void gpu_boost_on_touch(void)
drivers/media/video/samsung/mali/platform/pegasus-m400/mali_platform.c:void gpu_boost_on_touch(void)
drivers/media/video/samsung/mali_r3p0_lsi/common/mali_osk.h:#define gpu_boost_on_touch new_gpu_boost

em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c
em drivers/media/video/samsung/mali/common/mali_kernel_utilization.c

~/kernel/s5/siyahkernel3/
~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/
~/android/system_jbmali/kernel/samsung/smdk4210/

diff \
~/kernel/siyah/siyahkernel3-jbmali-vsync_sysfs/\
drivers/input/touchscreen/mxt224_u1.c \
~/kernel/dori/dorimanx/\
drivers/input/touchscreen/mxt224_u1.c \
> mxt224.diff

# update touchscreen
cp \
~/android/system_jbmali/kernel/samsung/smdk4210/\
drivers/input/touchscreen/mxt224_u1.c \
drivers/input/touchscreen/mxt224_u1.c

em drivers/input/touchscreen/Kconfig

em arch/arm/mach-exynos/mach-u1.c
em drivers/input/touchscreen/mxt224_u1.c
em drivers/sensor/cm3663.c
em drivers/input/keyboard/gpio_keys.c
em include/linux/i2c/mxt224_u1.h

em drivers/i2c/busses/i2c-s3c2410.c
em arch/arm/mach-exynos/u1-gpio.c

# update luzactiveq
cp \
~/kernel/s5/siyahkernel3/\
drivers/cpufreq/cpufreq_lulzactiveq.c \
drivers/cpufreq/cpufreq_lulzactiveq.c

add slide2wake & touch_lock_freq

cd /sys/devices/virtual/sec/sec_touchscreen
cd /sys/class/sec/sec_touchscreen

/home/changmin/android/system_jbmali/kernel/samsung/smdk4210/drivers/input/keyboard/gpio_keys.c: In function 'gpio_keys_probe':
/home/changmin/android/system_jbmali/kernel/samsung/smdk4210/drivers/input/keyboard/gpio_keys.c:613:3: error: implicit declaration of function 'slide2wake_setdev' [-Werror=implicit-function-declaration]

em arch/arm/configs/cyanogenmod_i9100_defconfig
em arch/arm/configs/siyah_s2_defconfig



# on
echo "1" > /sys/class/sec/sec_touchscreen/tsp_slide2wake

# off
echo "0" > /sys/class/sec/sec_touchscreen/tsp_slide2wake

tsp_slide2wake()
{
    if [ "$1" = "disable" ]; then
	echo -n "Tsp slide2wake: "
	echo "disable"
	return 0
    fi

    if [ -z "$(grep TSP_SLIDE2WAKE $TWEAKS_CONF)" ]; then
	echo "\n# TSP slide2wake: on, off, disable" >> $TWEAKS_CONF
	echo "TSP_SLIDE2WAKE=on" >> $TWEAKS_CONF
    fi

    local TSP_SLIDE2WAKE=on
    if [ -n "$1" ]; then
	TSP_SLIDE2WAKE=$1
    fi
    if [ "$TSP_SLIDE2WAKE" = "off" ]; then
	echo "0" > /sys/class/sec/sec_touchscreen/tsp_slide2wake
	echo "Tsp slide2wake: off"
    else
	echo "1" > /sys/class/sec/sec_touchscreen/tsp_slide2wake
	echo "Tsp slide2wake: on"
    fi
}
tsp_slide2wake $TSP_SLIDE2WAKE

echo "500000" > /sys/class/sec/sec_touchscreen/tsp_touch_freq
tsp_touch_freq()
{
    if [ "$1" = "disable" ]; then
	echo -n "Tsp touch freq: "
	echo "disable"
	return 0
    fi

    if [ -z "$(grep TSP_TOUCH_FREQ $TWEAKS_CONF)" ]; then
	echo "\n# TSP touch freq: 200000 ~ 1200000, disable" >> $TWEAKS_CONF
	echo "TSP_TOUCH_FREQ=500000" >> $TWEAKS_CONF
    fi

    local TSP_TOUCH_FREQ=500000
    if [ -n "$1" ]; then
	TSP_TOUCH_FREQ=$1
    fi
    echo $TSP_TOUCH_FREQ > /sys/class/sec/sec_touchscreen/tsp_touch_freq

    echo -n "Tsp touch freq: "
    cat /sys/class/sec/sec_touchscreen/tsp_touch_freq
}
tsp_touch_freq $TSP_TOUCH_FREQ


git am 0001-add-gpu_boost_on_touch-for-exynos4210.patch

em drivers/media/video/samsung/mali_r3p0_lsi/platform/orion-m400/mali_platform.c
em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c
em drivers/input/touchscreen/mxt224_u1.c
em drivers/input/keyboard/gpio_keys.c
em drivers/input/keyboard/cypress/cypress-touchkey.c
git format-patch -1

	<settingsPane description="Other Settings" name="Other Settings">

		<seekBar description="User adjustable gamma shift." 
			name="Gamma Shift" action="generic /sys/class/lcd/panel/user_gamma_adjust" 
			unit="" min="-50" reversed="false" step="5" max="50"/>

		<seekBar description="FB earlysuspend delay to run CRT animation when you turn the screen off." 
			name="FB Earlysuspend Delay" action="generickmem fbearlysuspend_delay 0 int" unit=" ms" min="0" reversed="false" step="50" max="500"/>

		<seekBar description="Vibration force level (default 75)" 
			name="Vibration Force" action="generic /sys/vibrator/pwm_val" unit="%" min="0" reversed="false" step="5" max="100"/>

		<seekBar description="Sets Touch screen cpu freq, when you touch the screen CPU will be boosted to that speed! default is 500000mHz)" 
			name="Touch screen lock freq" action="generic /sys/devices/virtual/sec/sec_touchscreen/tsp_touch_freq" 
			unit="mHz" min="100000" reversed="false" step="100000" max="1500000"/>

		<checkbox description="Slide2Wake By Fluxi@xda, when screen is OFF swipe from left side of screen to right side of screen, and screen will be turned ON!"
			name="Slide2Wake ON/OFF Switch" action="generic01 /sys/devices/virtual/sec/sec_touchscreen/tsp_slide2wake" label="Slide2Wake Switch"/>

		<checkbox description="Enable inverting the screen colors by quickly pressing Home button below configured times" 
			name="mDNIe Negative Toggle" action="generic01 /sys/module/gpio_keys/parameters/mdnie_shortcut_enabled" label="mDNIe Negative Toggle"/>

		<spinner description="Negative Color, Screen effect settings, Fast Click MENU for number of times configured to activate MOD" 
			name="Negative Screen Mod tuning." action="negative_tweak">
			<spinnerItem name="Set 4 Clicks (default)" value="1"/> 
			<spinnerItem name="Set 6 Clicks" value="2"/> 
		</spinner>

	</settingsPane>


arm_cpu_topology()
{
git format-patch 884b3c3cb68f14e1cdc2504b902cd5ce84d6f9cb..15c70c3f45c09181f32c077c41c5c1a1894e6f59
git am /home/changmin/workspace/arm_topology/*patch

em 0001-ARM-7011-1-Add-ARM-cpu-topology-definition.patch
em 0012-cpupower-update-the-cpu_power-according-to-cpu-load.patch
em 0014-RWSEM_XCHGADD_ALGORITHM-for-ARM-R-W-semaphores-imple.patch
ARM_CPU_TOPOLOGY
SCHED_MC
SCHED_SMT
CPUPOWER
RWSEM_XCHGADD_ALGORITHM

turn on ARM topology at kernel_defconfig
em arch/arm/configs/siyah_s2_defconfig
CONFIG_ARM_CPU_TOPOLOGY=y
CONFIG_SCHED_MC=y
# CONFIG_SCHED_SMT is not set

CONFIG_CPUPOWER=y
}

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_FS=y
CONFIG_SYNC=y
# CONFIG_SW_SYNC is not set
# CONFIG_SW_SYNC_USER is not set

# CNNFIG_DEBUG_KERNEL is not set
# CONFIG_DEBUG_FS is not set
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y

SYNC_ON_DEFCONFIG() {
    sed -i \
	-e 's/# CONFIG_SYNC is not set.*/CONFIG_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC is not set.*/CONFIG_SW_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC_USER is not set.*/CONFIG_SW_SYNC_USER=y/g' \
	defconfig
    grep -e CONFIG_SYNC -e CONFIG_SW_SYNC -e CONFIG_SW_SYNC_USER defconfig
    [ -e .config ] && rm .config
}

SYNC_OFF_DEFCONFIG() {
    sed -i \
	-e 's/# CONFIG_SYNC is not set.*/CONFIG_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC is not set.*/CONFIG_SW_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC_USER is not set.*/CONFIG_SW_SYNC_USER=y/g' \
	defconfig
    grep -e CONFIG_SYNC -e CONFIG_SW_SYNC -e CONFIG_SW_SYNC_USER defconfig
    [ -e .config ] && rm .config
}

# gpu voltage
em arch/arm/mach-exynos/mach-u1.c
static struct regulator_init_data buck3_init_data = {
	.constraints	= {
		.name		= "G3D_1.1V",
		.min_uV		= 800000,
		.max_uV		= 1400000,
		.always_on	= 0,
		.boot_on	= 0,
		.apply_uV	= 1,
		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE |
				  REGULATOR_CHANGE_STATUS,
		.state_mem	= {
			.mode		= REGULATOR_MODE_NORMAL,
			.disabled	= 1,
		},
	},
	.num_consumer_supplies	= 1,
	.consumer_supplies	= &buck3_supply[0],
};

cp \
~/kernel/s5/siyahkernel3/\
drivers/input/touchscreen/mxt224_u1.c \
drivers/input/touchscreen/mxt224_u1.c

cd drivers/net/wireless/
tar cvzf bcmdhd.tgz --exclude=*.o --exclude=*.cmd bcmdhd
tar cvzf bcmdhd-b2.tgz --exclude=*.o --exclude=*.cmd bcmdhd

tar xvzf /home/changmin/kernel/s5/siyahkernel3-b2/drivers/net/wireless/bcmdhd-b2.tgz


cp res/customconfig/actions/sound_volume /home/changmin/kernel/siyah/initramfs3/res/customconfig/actions/sound_volume

ls -l res/customconfig/actions/sound_volume
chmod 775 res/customconfig/actions/sound_volume

initramfs3/res/customconfig/

stmd5sum=`/sbin/busybox md5sum /system/app/STweaks.apk | /sbin/busybox awk '{print $1}'`
if [ "$stmd5sum" == "0936a23cbcf1092be8fba4a8905fcd22" ];then
    installstweaks=1
fi

cm10mr1() {
em hardware/libhardware_legacy/wifi/wifi.c
cd system/core/rootdir
em ./system/core/rootdir/ueventd.rc

cd device/samsung/galaxys2-common/
em init.smdk4210.rc

cp ~/download/cm-10.1/root/*.rc /home/changmin/kernel/siyah/initramfs3/res/misc/init.cm10.1/
cp ~/download/cm-10.1/root/init /home/changmin/kernel/siyah/initramfs3/res/misc/init.cm10.1/innt

CM10MR1=0
if [ -f /system/framework/mms-common.jar ] && [ -f /system/framework/settings.jar ] && [ -f /system/framework/telephony-common.jar ]; then
    CM10MR1=1
fi
if [ "$CM10MR1" == 1 ]; then
    echo ok
fi

em res/misc/init.cm10.1/init.rc

service postinit /sbin/ext/post-init.sh
	class core
	user root
	oneshot
}

em ../initramfs3/res/misc/init.cm10/init.rc
em ../initramfs3/res/misc/init.cm10.1/init.rc
em system/core/rootdir/init.rc

em drivers/iommu/Kconfig
EXYNOS_IOMMU
EXYNOS_IOVMM

CONFIG_EXYNOS_DEV_SYSMMU=y
CONFIG_EXYNOS_DEV_PD=y

# CONFIG_VIDEOBUF2_CMA_PHYS is not set
CONFIG_VIDEOBUF2_ION=y

CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_EXYNOS_IOMMU=y
CONFIG_EXYNOS_IOVMM=y

em arch/arm/plat-samsung/include/plat/iovmm.h
em arch/arm/plat-s5p/include/plat/s5p-iovmm.h

em drivers/media/video/videobuf2-ion.c
#define CONFIG_EXYNOS_IOMMU
#define CONFIG_EXYNOS_IOVMM

# v5: .siyah -> .siyah-v5
res/customconfig/customconfig-helper:PROFILE_PATH=/data/.siyah-v5
em res/customconfig/actions/install-root \
    sbin/ext/efs-backup.sh \
    sbin/ext/post-init.sh \
    sbin/ext/su-helper.sh

# v4: .siyah -> .siyah-v4
res/customconfig/customconfig-helper:PROFILE_PATH=/data/.siyah-v4
em res/customconfig/actions/install-root \
    sbin/ext/efs-backup.sh \
    sbin/ext/post-init.sh \
    sbin/ext/su-helper.sh

em drivers/cpufreq/cpufreq_ondemand.c drivers/cpufreq/cpufreq_pegasusq.c
#define MAX_FREQ_LIMIT                               (1000000)



//////////////////////
/**
 * boostfreq
 * /sys/devices/system/cpu/cpufreq/boostfreq
 */

unsigned int g_boostfreq = 500000;

static ssize_t show_boostfreq(struct kobject *kobj,
			      struct attribute *attr, char *buf)
{
	return sprintf(buf, "%u mhz\n", g_boostfreq / 1000);
}

static ssize_t store_boostfreq(struct kobject *kobj,
			       struct attribute *attr, const char *buf, size_t count)
{
	unsigned int input = 0;

	if (sscanf(buf, "%u", &input) != 1)
		return -EINVAL;

	input = input < 2000 ? input * 1000 : input;
	g_boostfreq = input < 1200000 ? input : 1200000;

	return count;
}

static struct global_attr boostfreq_attr = __ATTR(boostfreq,
	0666, show_boostfreq, store_boostfreq);

/////////////////////////////
	BUG_ON(!cpufreq_global_kobject);
	register_syscore_ops(&cpufreq_syscore_ops);

	if (sysfs_create_file(cpufreq_global_kobject, &boostfreq_attr.attr))
		pr_err("Failed to create sysfs file(boostfreq)\n");

adb shell "echo 500 > /sys/devices/system/cpu/cpufreq/boostfreq;cat /sys/devices/system/cpu/cpufreq/boostfreq;cat /sys/devices/system/cpu/cpufreq/pegasusq/boostfreq"
adb shell "echo 800 > /sys/devices/system/cpu/cpufreq/boostfreq;cat /sys/devices/system/cpu/cpufreq/boostfreq;cat /sys/devices/system/cpu/cpufreq/pegasusq/boostfreq"
adb shell "cat /sys/devices/system/cpu/cpufreq/boostfreq;cat /sys/devices/system/cpu/cpufreq/pegasusq/boostfreq"

///////////////////////////////////
static u64 freq_boosted_time;
extern unsigned int g_boostfreq;

static ssize_t store_boostpulse(struct kobject *kobj, struct attribute *attr,
				const char *buf, size_t count)
{
	int ret;
	unsigned int input;

	ret = sscanf(buf, "%u", &input);
	if (ret < 0)
		return ret;

	// cpufreq.c /sys/devices/system/cpu/cpufreq/boostfreq
	dbs_tuners_ins.boostfreq = g_boostfreq;

	if (input > 1 && input <= MAX_FREQ_BOOST_TIME)
		dbs_tuners_ins.freq_boost_time = input;
	else
		dbs_tuners_ins.freq_boost_time = DEFAULT_FREQ_BOOST_TIME;

	dbs_tuners_ins.boosted = 1;
	freq_boosted_time = ktime_to_us(ktime_get());

	return count;
}

static ssize_t store_boostfreq(struct kobject *a, struct attribute *b,
			       const char *buf, size_t count)
{
	unsigned int input = 0;

	if (sscanf(buf, "%u", &input) != 1)
		return -EINVAL;

	input = input < 2000 ? input * 1000 : input;
	g_boostfreq = input < 1200000 ? input : 1200000;
	dbs_tuners_ins.boostfreq = g_boostfreq;

	return count;
}

adb shell "echo 1 > /sys/devices/system/cpu/cpufreq/pegasusq/boostpulse"

init.rc() {
    symlink /data/local/userinit.d /userinit.d
}

interactive_boostpulse() {
em drivers/cpufreq/cpufreq_interactive.c
em include/trace/events/cpufreq_interactive.h
em drivers/cpufreq/cpufreq_interactive.c include/trace/events/cpufreq_interactive.h

cd /sys/devices/system/cpu/cpufreq/interactive
cat /sys/devices/system/cpu/cpufreq/interactive/boostfreq
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/boostpulse

}


iovmm_map' undeclared
iovmm_map' undeclared