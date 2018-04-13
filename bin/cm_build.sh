#!/bin/bash

echo -n "# ";cat ~/download/cmbuild.txt | grep SYNC | tail -n 1

change_repo_branch_revision() {
    em .repo/manifests.git/config

[branch "default"]
	remote = origin
	merge = jellybean

[branch "default"]
	remote = origin
	merge = mr1-staging

[branch "default"]
	remote = origin
	merge = cm-10.1
}

jpeg-turbo()
{
    cm
    em .repo/local_manifest.xml
    cat <<EOF >> .repo/local_manifest.xml
<manifest>
    <remote fetch="git://git.linaro.org/" name="linaro" />
    <remove-project name="CyanogenMod/android_external_jpeg" />
    <project path="external/jpeg" name="people/tomgall/libjpeg-turbo-leb/libjpeg-turbo" remote="linaro" revision="android" />
    <!-- <project path="external/jpeg" name="people/tomgall/libjpeg-turbo/libjpeg-turbo" remote="linaro" revision="android" /> -->
</manifest>
EOF
    cm;cd out
    findexec *jpeg* "rm -rf"
}

cm;em vendor/cm/prebuilt/common/bin/gpucat

proprietary() {
    cm;cd hardware/samsung/
    cm;cd vendor/samsung/galaxys2-common
    cm;cd device/samsung/galaxys2-common
    cm;cd vendor/samsung/i9100
    cm;cd device/samsung/i9100

    # build.prop
    cm;em build/core/main.mk	#build.prop 기본 설정
    cm;em frameworks/native/build/phone-hdpi-512-dalvik-heap.mk # dalvik.vm.heap 설정 파일

    cm;em device/samsung/i9100/cm.mk
    cm;em device/samsung/galaxys2-common/common.mk # 추가로 복사해야될 파일이 있으면 common.mk에 설정하면 된다
    cm;em vendor/samsung/galaxys2-common/common-vendor-blobs.mk
    cm;em device/samsung/galaxys2-common/BoardCommonConfig.mk

    cm;em system/core/rootdir/init.rc
    cm;em device/samsung/galaxys2-common/init.smdk4210.rc

    cm;em buildscripts/targets/i9100/kernel_updater-script

    cm;cd device/samsung/galaxys2-common/overlay/
    cm;cd vendor/samsung/galaxys2-common/proprietary/
    cm;em vendor/samsung/galaxys2-common/proprietary/Android.mk

    # Trebuchet config.xml
    cm;em device/samsung/galaxys2-common/overlay/packages/apps/Trebuchet/res/values/config.xml
    cm;em packages/apps/Trebuchet/res/values/config.xml
}

cm_debug()
{
    # 상태바 열었다 닫았다 하면 메모리릭 증세 보임
    # git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/76/23676/1 && git cherry-pick FETCH_HEAD
    cm;cd frameworks/base
    cm;em frameworks/base/services/java/com/android/server/InputMethodManagerService.java #:1684:
    cm;em frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/PhoneStatusBar.java #:1166:
    # 두파일 디버그 메세지 각각 주석 처리
}

cm_makefile()
{
    #cp ~/workspace/kmemhelper vendor/cm/prebuilt/common/bin/kmemhelper
    ls -l vendor/cm/prebuilt/common/bin/kmemhelper
    cm;em build/core/Makefile
    cm;em vendor/cm/prebuilt/common/etc/init.d/21config
    cm;em vendor/cm/prebuilt/common/etc/init.d/20tweaks
    cm;em vendor/cm/prebuilt/common/etc/init.d/S90zipalign
    cm;em vendor/cm/config/common.mk
	# tweakinit support
	    # PRODUCT_COPY_FILES += \
	    # vendor/cm/prebuilt/common/etc/init.d/20tweaks:system/etc/init.d/20tweaks \
	    # vendor/cm/prebuilt/common/bin/kmemhelper:system/bin/kmemhelper \
	    # vendor/cm/prebuilt/common/bin/remount:system/bin/remount

	#CM_EXPERIMENTAL := 0
	#CM_EXTRAVERSION := changmin

    cm;em device/samsung/galaxys2-common/BoardCommonConfig.mk
    cm;em device/samsung/i9100/BoardConfig.mk
        #TARGET_OTA_ASSERT_DEVICE := galaxys2,i9100,GT-I9100,GT-I9100M,GT-I9100P,GT-I9100T,SHW-M250S,SHW-M250K
	#BOARD_CUSTOM_VSYNC_IOCTL := true
	#BOARD_USE_V4L2_ION := true
    cm;em hardware/samsung/exynos4/hal/libhwcomposer/Android.mk
	#LOCAL_CFLAGS += -DVSYNC_IOCTL
    cm;em kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig

    cm;cd vendor/samsung/
    em galaxys2-common/common-vendor-blobs.mk
}

governor()
{
    cm;4210;
    em arch/arm/mach-exynos/stand-hotplug.c
    em drivers/cpufreq/cpufreq_pegasusq.c
    em drivers/cpufreq/cpufreq_lulzactiveq.c
}

revert_ioctl_vsync()
{
    cd ~/android/devel/kernel/samsung/smdk4210/drivers/video/
    cp fbmem.c ~/android/system/kernel/samsung/smdk4210/drivers/video/
    cd ~/android/devel/kernel/samsung/smdk4210/drivers/video/samsung
    cp s3cfb.h s3cfb_ops.c s3cfb_main.c ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/
}

cm_hwcomposer()
{
    cm;cd out;findexec hwcomposer* "rm -rf";findexec SecHWC* "rm -rf"
    cm;. build/envsetup.sh;lunch cm_i9100-userdebug
    cm;make hwcomposer.exynos4

    cm;cd vendor/samsung/galaxys2-common/proprietary/system/lib/hw
    cm;em vendor/samsung/galaxys2-common/common-vendor-blobs.mk
    cat <<EOF
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/proprietary/system/lib/hw/hwcomposer.smdk4210.so:system/lib/hw/hwcomposer.smdk4210.so \
EOF

    cm;em device/samsung/galaxys2-common/common.mk
    cat <<EOF
PRODUCT_PACKAGES += \
    hwcomposer.exynos4 \
TARGET_HAL_PATH := hardware/samsung/exynos4/hal
EOF
    hwc;
    cm;em hardware/samsung/exynos4/hal/Android.mk
    cm;em hardware/samsung/exynos4/hal/include/s3c_lcd.h
    cm;em hardware/samsung/exynos4/hal/libhwcomposer/Android.mk
    cm;em hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp
    cm;em hardware/samsung/exynos4/hal/libhwcomposer/SecHWCUtils.h

    ## KERNEL ##################################
    cm;cd kernel/samsung/smdk4210
    em kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
	# CONFIG_FB_S5P_VSYNC_THREAD is not set
	# CONFIG_FB_S5P_VSYNC_THREAD=y
    em kernel/samsung/smdk4210/drivers/video/samsung/s3cfb.h
	# #define VSYNC_TIMEOUT_MSEC 50
	# fcb->wq
	# fcb->vsync_info.timestamp
	# S3CFB_WAIT_FOR_VSYNC
    cm;em kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c
	# fbdev[i]->update_regs_thread = kthread_run(kthread_worker_fn, &fbdev[i]->update_regs_worker, "s3c-fb");
	# fbdev[i]->vsync_info.thread = kthread_run(s3cfb_wait_for_vsync_thread,fbdev[i], "s3c-fb-vsync");
    cm;em kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_ops.c
    em drivers/video/fbmem.c
}

new_mali_driver_conflict()
{
    em drivers/media/video/samsung/mali/linux/mali_kernel_linux.c
    em drivers/media/video/samsung/mali/platform/mali_platform.h
    em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c
    em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform_dvfs.c
}

test()
{
    echo "40 160 200 267" > /sys/class/misc/gpu_clock_control/gpu_control;
    echo "70% 50% 85% 50% 85% 70%" > /sys/class/misc/gpu_clock_control/gpu_control;
    echo "800000 950000 1000000 1050000" > /sys/devices/virtual/misc/gpu_voltage_control/gpu_control;

    smdk;cd drivers/media/video/samsung/mali/platform/orion-m400/

    smdk;cd drivers/media/video/samsung/mali/
    em Makefile
# ifeq ($(USING_MALI_DVFS_ENABLED),1)
# mali-y += $(MALI_PLATFORM_DIR)/mali_platform_dvfs.o
# mali-y += common/gpu_clock_control.o
# mali-y += common/gpu_voltage_control.o
# endif #($(USING_MALI_DVFS_ENABLED),1)
    smdk;cd drivers/media/video/samsung/mali/linux/
    em mali_kernel_pm.c

    smdk;em arch/arm/configs/cyanogenmod_i9100_defconfig
    # CONFIG_GPU_CLOCK_CONTROL=y
    # CONFIG_REGULATOR=y
    mount -t vfat /dev/block/mmcblk0p11 /storage/sdcard0
    dd if=boot.img of=/dev/block/mmcblk0p5 bs=4096
    cd; 7z u -r cm-10-20120926-EXPERIMENTAL-i9100-changmin.zip system/
}
exit

# todo:
cpu_boosts_power()
{
    cm;cd hardware/samsung/exynos4/exynos4210/power
    em hardware/samsung/exynos4/exynos4210/Android.mk
    em hardware/samsung/exynos4/exynos4210/power/power.c
}

no_scrolling_cache()
{
# http://forum.xda-developers.com/showthread.php?t=1411317
    cm;cd frameworks/base
    em core/java/android/widget/AbsListView.java
    # createScrollingCache	4879
    # initAbsListView		808
    # setScrollingCacheEnabled	1568
}

mali_config()
{
em arch/arm/configs/cyanogenmod_i9100_defconfig
em arch/arm/configs/siyah_defconfig

CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
CONFIG_ION_EXYNOS_CONTIGHEAP_SIZE=71680

# CONFIG_SW_SYNC is not set
# CONFIG_SW_SYNC_USER is not set
# CONFIG_ION_EXYNOS_CONTIGHEAP_SIZE is not set
}

cm;cd frameworks/base;em telephony/java/com/android/internal/telephony/Smdk4210RIL.java

mc1n2()
{
    smdk;cd sound/soc/codecs/mc1n2;
    sj;cd sound/soc/codecs/mc1n2;
    
#backup
    cp mc1n2.c mcresctrl.c mc1n2_cfg.h ~/workspace/mc1n2/
#copy from siyha
    sj;cd sound/soc/codecs/mc1n2;
    cp mc1n2.c mcresctrl.c /home/changmin/android/system_jbmali/kernel/samsung/smdk4210/sound/soc/codecs/mc1n2
    cp mc1n2.c mcresctrl.c /home/changmin/android/system_vsync/kernel/samsung/smdk4210/sound/soc/codecs/mc1n2

    cp ~/kernel/siyah/initramfs3/sbin/kmemhelper /home/changmin/android/system_jbmali/vendor/cm/prebuilt/common/bin
    cp ~/kernel/siyah/initramfs3/sbin/kmemhelper /home/changmin/android/system_vsync/vendor/cm/prebuilt/common/bin

    vs;em vendor/cm/prebuilt/common/etc/init.d/20tweaks
    mali;em vendor/cm/prebuilt/common/etc/init.d/20tweaks

    vs;em vendor/cm/prebuilt/common/etc/init.d/21config
    mali;em vendor/cm/prebuilt/common/etc/init.d/21config
    
    vs;em vendor/cm/config/common.mk
    mali;em vendor/cm/config/common.mk
	# tweakinit support
	    # PRODUCT_COPY_FILES += \
	    # vendor/cm/prebuilt/common/etc/init.d/20tweaks:system/etc/init.d/20tweaks \
            # vendor/cm/prebuilt/common/etc/init.d/21config:system/etc/init.d/21config \
	    # vendor/cm/prebuilt/common/bin/remount:system/bin/remount
setprop wifi.supplicant_scan_interval 300

    em mc1n2.c
    em mcresctrl.c
    em mc1n2_cfg.h
    
    mali;smdk;em sound/soc/codecs/mc1n2/mc1n2.c
    vs;smdk;em sound/soc/codecs/mc1n2/mc1n2.c
}

try_diff()
{
    # gpu boost 관련 mutexlock 추가
    cm;em kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
    cm;em kernel/samsung/smdk4210/drivers/video/samsung/s3cfb.h

    mali;smdk;em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c
    vs;smdk;em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c
    js;em drivers/media/video/samsung/mali/platform/orion-m400/mali_platform.c
}

movihysti()
{
    vs;smdk;em arch/arm/mach-exynos/mach-u1.c
    mali;smdk;em arch/arm/mach-exynos/mach-u1.c

    mali;smdk;em arch/arm/mach-exynos/mach-px.c
    js;em arch/arm/mach-exynos/mach-px.c
}

tdmb()
{
cm;em kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
# CONFIG_TDMB is not set
CONFIG_TDMB=y
CONFIG_TDMB_SPI=y
CONFIG_TDMB_VENDOR_INC=y
CONFIG_TDMB_T3900=y
CONFIG_TDMB_VENDOR_TELECHIPS=y
CONFIG_TDMB_TCC3170=y
}

watch -n 1 cat /sys/module/mali/parameters/mali_gpu_clk /sys/module/mali/parameters/mali_gpu_vol

cm;em vendor/cm/config/common.mk
    vendor/cm/prebuilt/common/bin/gpuwatch:system/bin/gpuwatch \
    vendor/cm/prebuilt/common/bin/gpucat:system/bin/gpucat \
cm;cd vendor/cm/prebuilt/common/bin
    cp ~/workspace/gpu* .

gpu_cat()
{
echo -n "gpu clock: "
cat /sys/module/mali/parameters/mali_gpu_clk
echo -n "gpu voltage: "
cat /sys/module/mali/parameters/mali_gpu_vol
}

mali;cmsync;./cmb;vs;cmsync;./cmb

frameworks/native/services/surfaceflinger/DisplayHardware/HWComposer.cpp
hardware/libhardware/include/hardware/hwcomposer.h
hardware/libhardware/include/hardware/hwcomposer_defs.h
hardware/qcom/display/libhwcomposer/hwc.cpp
hardware/samsung/exynos3/s5pc110/libhwcomposer/SecHWC.cpp
hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp
hardware/ti/omap4xxx/hwc/hwc.c

# enable kmem interface for everyone by GM
echo "0" > /proc/sys/kernel/kptr_restrict;

case "$soundgasm_hp" in
        0)
                kmemhelper -t short -n mc1n2_vol_hpgain -o 0 0;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 2 0;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 4 0;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 6 0;
                echo "1e 1" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
                echo "1e 0" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
        ;;
        1)
                kmemhelper -t short -n mc1n2_vol_hpgain -o 0 384;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 2 384;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 4 384;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 6 384;
                echo "1e 1" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
                echo "1e 0" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
        ;;
        2)
                kmemhelper -t short -n mc1n2_vol_hpgain -o 0 768;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 2 768;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 4 768;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 6 768;
                echo "1e 1" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
                echo "1e 0" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
        ;;
        3)
                kmemhelper -t short -n mc1n2_vol_hpgain -o 0 1536;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 2 1536;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 4 1536;
                kmemhelper -t short -n mc1n2_vol_hpgain -o 6 1536;
                echo "1e 1" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
                echo "1e 0" > /sys/kernel/debug/asoc/U1-YMU823/mc1n2.6-003a/codec_reg;
        ;;
esac;

// 79.2 mW    1.2 ms/s  19.6        Process [s3c-fb-vsync]

em arch/arm/kernel/smp.c
#61
static DECLARE_COMPLETION(cpu_running);
#126
wait_for_completion_timeout(&cpu_running, msecs_to_jiffies(1000));
#328
complete(&cpu_running);


# vsync_off
#define NO_HW_VSYNC

#ifndef NO_HW_VSYNC
#endif	//NO_HW_VSYNC

cm;cd out;findrm *webcore*;cm



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

# config: Remove profiling, remove size optimization
smdk;em arch/arm/configs/cyanogenmod_i9100_defconfig
git fetch http://review.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4210 refs/changes/30/25030/2 && git cherry-pick FETCH_HEAD

em drivers/video/samsung/s3cfb_ops.c

# jb hwc from note.
-rw-r--r-- 1 changmin changmin  30260 10월 25 03:56 hwcomposer.smdk4210.so

# recovery mount
mount /dev/block/mmcblk0p9 /system/
mkdir /sdcard;mount /dev/block/mmcblk0p11 /sdcard

scroll_cache()
{
    if [ "$1" = "disable" ]; then
	echo -n "scroll cache: "
	echo "disable"
	return 0;
    fi

    if [ -z "$(grep SCROLL_CACHE $TWEAKS_CONF)" ]; then
	echo "\n# Scroll cache(needs restart): on, off, disable" >> $TWEAKS_CONF
	echo "SCROLL_CACHE=off" >> $TWEAKS_CONF
    fi

    local SCROLL_CACHE=on
    if [ -n "$1" ]; then
	SCROLL_CACHE=$1
    fi

    if [ ! $(grep -e '^persist.sys.scrollingcache' /data/local.prop) ]; then
	# 0(on) ~ 3(off)
	echo "persist.sys.scrollingcache=0" >> /data/local.prop
    fi

    if [ "$SCROLL_CACHE" = "off" ]; then
	sed -i -e 's/^persist.sys.scrollingcache.*/persist.sys.scrollingcache=3/g' /data/local.prop
	echo "scroll cache: off"
    else
	sed -i -e 's/^persist.sys.scrollingcache.*/persist.sys.scrollingcache=0/g' /data/local.prop
	echo "scroll cache: on"
    fi
}


charge_current()
{
em drivers/power/charge_current.h
em drivers/power/charge_current.c
em drivers/power/sec_battery_u1.c

cat /sys/class/misc/charge_current/charge_current
AC: 650
Misc: 650
USB: 650

echo "650 650 650" > /sys/class/misc/charge_current/charge_current
}

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

/sys/class/misc/mali_control/voltage_control
/sys/class/misc/mali_control/clock_control

[localhost / # cat /sys/class/misc/mali_control/clock_control
Step0: 50                                                                                         
Step1: 100                                                                                        
Step2: 134                                                                                        
Step3: 160                                                                                        
Step4: 267                                                                                        

localhost / # cat /sys/class/misc/mali_control/voltage_control
Step1: 900000                                                                                     
Step2: 900000                                                                                     
Step3: 950000                                                                                     
Step4: 950000                                                                                     
Step5: 1000000

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

git format-patch 2e6b8474822095654ee3d4789be90cbc16be13f3..b84523898298325f4f192649546e8d23e8b212fd
git am /home/changmin/workspace/arm_topology/*patch

rm defconfig;ln -s arch/arm/configs/cyanogenmod_i9100_defconfig defconfig

sed --follow-symlinks
rm defconfig; ln -s arch/arm/configs/siyah_s2_defconfig defconfig

# tcp buffersize
http://review.cyanogenmod.org/#/c/24692/
# hspap
http://review.cyanogenmod.org/#/c/24957/

feb666d4830074c3a78d820e98a3781ecf351e0c
6479e181cbdd94d2c1de6f8a96ab8c118c6230b4

em system/core/rootdir/init.rc
cd system/core
em rootdir/init.rc
+    setprop net.tcp.buffersize.hspap   4094,87380,1220608,4096,16384,1220608

em drivers/motor/tspdrv.c
em drivers/motor/max8997_vibrator.c

drivers/motor/tspdrv.c
drivers/motor/max8997_vibrator.c

adb shell 'echo 9 > /sys/vibrator/vibrator_level'
adb shell 'cat /sys/vibrator/vibrator_level'

echo 9 > /sys/vibrator/vibrator_level
cat /sys/vibrator/vibrator_level

echo -1 > /sys/vibrator/vibrator_level
cat /sys/vibrator/vibrator_level

# "Clear all" button on recent apps (Patch set 5)

###############################################################################
# 4.2
em .repo/manifests.git/config
merge = mr1-staging
refs/heads/mr1-staging

########
cm;em device/samsung/galaxys2-common/BoardCommonConfig.mk 
cm;em device/samsung/i9100/BoardConfig.mk
BOARD_USE_SYSFS_VSYNC_NOTIFICATION := true
BOARD_USE_V4L2_ION := true
########

em hardware/samsung/exynos4/hal/libgralloc_ump/Android.mk 
em hardware/samsung/exynos4/hal/libhwcomposer/Android.mk 
em hardware/samsung/exynos4/hal/libhwconverter/Android.mk 
em hardware/samsung/exynos4/hal/libhdmi/Android.mk 
em hardware/samsung/exynos4/hal/libs5pjpeg/Android.mk
em hardware/samsung/exynos4/hal/libfimg3x/Android.mk

em hardware/samsung/exynos/multimedia/codecs/video/exynos4/mfc/Android.mk
em hardware/samsung/exynos/multimedia/libstagefrighthw/Android.mk
em hardware/samsung/exynos/multimedia/openmax/osal/Android.mk
em hardware/samsung/exynos/multimedia/openmax/core/Android.mk
em hardware/samsung/exynos/multimedia/openmax/component/common/Android.mk
em hardware/samsung/exynos/multimedia/openmax/component/video/dec/Android.mk
em hardware/samsung/exynos/multimedia/openmax/component/video/dec/mpeg4/Android.mk
em hardware/samsung/exynos/multimedia/openmax/component/video/dec/vc1/Android.mk
em hardware/samsung/exynos/multimedia/openmax/component/video/enc/Android.mk
em hardware/samsung/exynos/multimedia/openmax/component/video/enc/h264/Android.mk

cherry_picks() {
    git format-patch -1 HEAD

    cm;cd external/llvm/
#llvm: Fix building libLLVMSupport
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_external_llvm refs/changes/99/28199/1 && git cherry-pick FETCH_HEAD

    cm;cd packages/apps/Settings/
#Settings : NavigationBar Customization
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/72/28172/2 && git cherry-pick FETCH_HEAD
#SoundSettings: Show DSPManager http://review.cyanogenmod.org/#/c/28234/1
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/34/28234/1 && git cherry-pick FETCH_HEAD
#Fix possible NPE(NullPointerException) http://review.cyanogenmod.org/#/c/28242/1
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/42/28242/1 && git cherry-pick FETCH_HEAD
#Port "Option to control cursor in text fields using volume keys (2/2)" http://review.cyanogenmod.org/#/c/28162/
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/62/28162/2 && git cherry-pick FETCH_HEAD

    cm;cd frameworks/base
#"Clear all" button on recent apps
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/72/27372/1 && git cherry-pick FETCH_HEAD
#Smooth Spinners: Makes the loading "spinner" animation smoother in non-holo apps
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/35/26635/2 && git cherry-pick FETCH_HEAD
#NavigationBar : Customization
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/73/28173/1 && git cherry-pick FETCH_HEAD
#Port "Framework Track Control : Switch from broadcast to audio service" http://review.cyanogenmod.org/#/c/28248/1
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/48/28248/1 && git cherry-pick FETCH_HEAD
#Port "Option to control cursor in text fields using volume keys (1/2)" http://review.cyanogenmod.org/#/c/28160/
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/60/28160/1 && git cherry-pick FETCH_HEAD
#services: Fix tethering (softap) startup. http://review.cyanogenmod.org/#/c/28243/
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/43/28243/4 && git cherry-pick FETCH_HEAD
    git am 0001-services-Fix-tethering-softap-startup-missing-import.patch

    cm;cd frameworks/av
#exynos4: add ION support
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/22/27622/4 && git cherry-pick FETCH_HEAD

    cm;cd frameworks/native
#binder: Add MemoryHeapBaseIon
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/19/27619/2 && git cherry-pick FETCH_HEAD
#exynos4: Add HWC_HWOVERLAY for video
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/69/27569/1 && git cherry-pick FETCH_HEAD
#libui: exynos4: Use legacy (4.1) usage flag on buffer allocation
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/92/27292/1 && git cherry-pick FETCH_HEAD

    cm;cd packages/apps/Contacts/
#Contacts: Fix dialpad image for korean
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Contacts refs/changes/38/27638/1 && git cherry-pick FETCH_HEAD

#Add stubs to make libtvoutinterface.so and camera to play nice
    cm;cd device/samsung/galaxys2-common/
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_samsung_galaxys2-common refs/changes/76/27776/1 && git cherry-pick FETCH_HEAD

    cm;cd hardware/samsung
#exynos4: gralloc: Do FIMC1 memory allocations from ION instead of FIMC1
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_hardware_samsung refs/changes/03/27703/2 && git cherry-pick FETCH_HEAD
#hwc: Pull in updates from exynos3 hwc
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_hardware_samsung refs/changes/71/27771/1 && git cherry-pick FETCH_HEAD

    cm;cd packages/apps/DeskClock
#Clock: fix layout for 320dp devices
    #git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_DeskClock refs/changes/01/28001/3 && git cherry-pick FETCH_HEAD
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_DeskClock refs/changes/88/28188/1 && git cherry-pick FETCH_HEAD
#clock: added flip and shake features
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_DeskClock refs/changes/52/27152/5 && git cherry-pick FETCH_HEAD
}

force_4xMSAA() {
    packages/apps/Settings/src/com/android/settings/DevelopmentSettings.java
    debug.egl.force_msaa=1
}

dalivikvm_debuglog() {
    em dalvik/vm/alloc/Heap.cpp
}

em frameworks/native/libs/gui/ConsumerBase.cpp
em frameworks/native/libs/gui/BufferQueue.cpp

    mMaxAcquiredBufferCount(1),
    mDefaultMaxBufferCount(2),

    mMaxAcquiredBufferCount(2),
    mDefaultMaxBufferCount(3),

cm;cd frameworks/native

E/ACodec  ( 1869): dequeueBuffer failed.
E/SurfaceTextureClient( 1869): queueBuffer: error queuing buffer to SurfaceTexture, -32
E/NuPlayer( 1869): Received error from video decoder, aborting playback.
E/NuPlayer( 1869): video track encountered an error (-2147483648)
E/Trace   ( 4923): error opening trace file: No such file or directory (2)
E/Trace   ( 4941): error opening trace file: No such file or directory (2)

av_ion() {
    cm;cd frameworks/av
#exynos4: add ION support
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/22/27622/4 && git cherry-pick FETCH_HEAD

    cm;cd frameworks/av

    em media/libstagefright/ACodec.cpp
-    if (!strcasecmp(mComponentName.c_str(), "OMX.Exynos.AVC.Decoder")) {
+    if (!strcasecmp(mComponentName.c_str(), "OMX.Exynos.AVC.Decoder")
+	|| !strcasecmp(mComponentName.c_str(), "OMX.SEC.AVC.Decoder")
+        || !strcasecmp(mComponentName.c_str(), "OMX.SEC.FP.AVC.Decoder")) {


    em media/libstagefright/Android.mk
    em media/libstagefright/colorconversion/Android.mk
    em services/camera/libcameraservice/Android.mk

ifeq ($(BOARD_USE_V4L2_ION),true)
LOCAL_SHARED_LIBRARIES += libsecion
endif

}

/data/misc/wifi/sockets/p2p0
/data/misc/wifi/hostapd.conf

# opensource_gralloc_copy()
# {
#     if [ ! -f /system/lib/hw/os.gralloc.exynos4.so ] || [ ! -f /system/lib/hw/ss.gralloc.exynos4.so ]; then
# 	return 1
#     fi

#     if [ -z "$(grep OPENSOURCE_GRALLOC $TWEAKS_CONF)" ]; then
# 	echo "\n# opensource gralloc(needs restart): on, off(samsung's blob)" >> $TWEAKS_CONF
# 	echo "OPENSOURCE_GRALLOC=off" >> $TWEAKS_CONF
#     fi

#     local OPENSOURCE_GRALLOC=off
#     if [ -n "$1" ]; then
# 	OPENSOURCE_GRALLOC=$1
#     fi

#     mount -o remount,rw /system
#     rm /system/lib/hw/gralloc.exynos4.so
#     if [ "$OPENSOURCE_GRALLOC" = "on" ]; then
# 	cp -a /system/lib/hw/os.gralloc.exynos4.so /system/lib/hw/gralloc.exynos4.so
# 	echo "opensource gralloc: on"
#     else
# 	cp -a /system/lib/hw/ss.gralloc.exynos4.so /system/lib/hw/gralloc.exynos4.so
# 	echo "opensource gralloc: off"
#     fi
#     chmod 644 /system/lib/hw/gralloc.exynos4.so
#     mount -o remount,ro /system
# }

#cptar /mnt/android-ext4-ssd/system_mr0 /mnt/data-ext4-hdd/android/system_mr0


MODEL_NAME=$(getprop ro.product.model)

GT-I9100P
SHW-M250S
SHW-M250K

webkit() {
cm;cd external/webkit/
cm;em external/webkit/Android.mk

ifeq ($(ENABLE_SKIA_GPU),true)
LOCAL_CFLAGS += -DENABLE_SKIA_GPU=1
endif

cm;em device/samsung/galaxys2-common/BoardCommonConfig.mk
ENABLE_SKIA_GPU := true

cm;cd out;findrm *libwebcore*;cm

cp out/target/product/i9100/system/lib/libwebcore.so ~/android/lib_mr1/system/lib/libwebcore-gpu.so
cp out/target/product/i9100/system/lib/libwebcore.so ~/android/lib_mr1/system/lib/libwebcore-orig.so

/system/lib/libwebcore.so
/system/lib/libwebcore-orig.so
}

skia() {
    cm;cd out;findrm *kia*;cm

    cm;em hardware/samsung/exynos4/hal/Android.mk
    cm;cd external/skia/Android.mk
    cm;cd external/skia
}

em hardware/samsung/exynos4/hal/power/power.c


set_boostpulse_freq() {
    GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
    BOOSTFREQ_PATH=/sys/devices/system/cpu/cpufreq/$GOVERNOR/boostfreq

    echo "$(($1*1000))" > $BOOSTFREQ_PATH
    BOOSTFREQ_MHZ=$(($(cat $BOOSTFREQ_PATH)/1000))
    echo "[$GOVERNOR] boostpulse freq: $BOOSTFREQ_MHZ Mhz"
}

set_boostfreq 900
echo $GOVERNOR $BOOSTFREQ

# 1200mhz 1000mhz 800mhz 500mhz 200mhz
echo "1300 1200 1100 1000 975 " > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

adb shell su -c "echo 1200 1100 975 900 825  > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table"

adb shell su -c "cat /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table"

echo 1 > /sys/devices/system/cpu/sched_mc_power_savings                                      
echo 1200 1100 975 900 825  > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

echo 1200 1100 975 900 825  > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table

cat /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
cat /sys/devices/system/cpu/sched_mc_power_savings


# 3번째열(필드3) 잘라내기
cut -d " " -f3
mount | grep relatime | cut -d " " -f3

echo 1200 1100 975 900 825 > /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
cat /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table


lock_clock() {
    cm;cd packages/apps/LockClock/res/values-ko
    em ~/android/system_mr1/packages/apps/LockClock/res/values-ko/strings.xml
    adbroot
    cmsetup
    make LockClock
    adb push /home/changmin/android/system_mr1/out/target/product/i9100/system/app/LockClock.apk /system/app && adb shell "chmod 0644 /system/app/LockClock.apk"

}

# if [ -f /data/.sdcardext4 ]; then
#     exec sfsck /dev/block/mmcblk1p1  ext4
#     mount ext4 /dev/block/mmcblk1p1  /storage/sdcard0 nosuid nodev noatime wait noauto_da_alloc
#     exec sfsck /dev/block/mmcblk0p11 ext4
#     mount ext4 /dev/block/mmcblk0p11 /storage/sdcard1 nosuid nodev noatime wait noauto_da_alloc
# fi

mount -rw -o noauto_da_alloc,nosuid,nodev,noatime,nodiratime -t ext4 /dev/block/vold/179:25 /storage/sdcard0
mount -rw -o noauto_da_alloc,nosuid,nodev,noatime,nodiratime -t ext4 /dev/block/vold/259:4 /storage/sdcard1
busybox mount -rw -o noauto_da_alloc,nosuid,nodev,noatime,nodiratime -t auto /dev/block/mmcblk1p1 /storage/sdcard0
busybox mount -rw -o noauto_da_alloc,nosuid,nodev,noatime,nodiratime -t auto /dev/block/mmcblk0p11 /storage/sdcard1

mkdir -p /mnt/obb/sdcard0_tmp
sdcard /mnt/sdcard0_tmp /storage/sdcard0 1000 1015

make_vold() {
    em system/vold/Ext4.cpp
    cmsetup
    make vold
    adbroot;adb push /home/changmin/android/system_mr1/out/target/product/i9100/system/bin/vold /system/bin/vold && adb shell "chmod 0755 /system/bin/vold"
}

make qrngd qrngtest
adbroot; 
adb push /home/changmin/android/system_mr1/out/target/product/i9100/system/bin/qrngd /system/bin
adb push /home/changmin/android/system_mr1/out/target/product/i9100/system/bin/qrngtest /system/bin
adb shell chmod 755 /system/bin/qrng*

#https://github.com/nunogil/lge-kernel-sniper/commit/3796a70bb4b817d51f2df1616fcf5c615c0c54f1
# From 0 .. 100.  Higher means more swappy (default: 60)
sysctl -w vm.swappiness=0
sysctl vm.swappiness

samsunglibs() {
    cd ~/download/android/rom/factoryfs-uh07/lib

    SAMLIB=~/download/android/rom/factoryfs-uh07/lib
    cp $SAMLIB/libsomx* /home/changmin/android/lib_mr1/system/lib
    cp $SAMLIB/*jpeg* /home/changmin/android/lib_mr1/system/lib
    cp $SAMLIB/*fim* /home/changmin/android/lib_mr1/system/lib
    cp $SAMLIB/*sec* /home/changmin/android/lib_mr1/system/lib
    rm /home/changmin/android/lib_mr1/system/lib/*ril*
}

extweaks() {
    sed -i -e "s/^T=.*/T=${}/g" /data/config.txt

    boostfreq
    gralloc: opensource samsung
    skia: default fimg2d3x
    vmtweaks: disable nunogil default
    seeder: default rngd qrngd

    mediascanner: default on off
    scrollcache: default on off
    navigationbar: default on off

    usb-mode
    cfs-tweaks
    sound_volume
    eargasm_hp
    mali_touch_boost_level
    logger
    mov_hysti
    tsp_slide2wake

    cp skia gralloc scrollcache mediascanner navigationbar vmtweaks \
	/home/changmin/kernel/siyah-v5/siyahkernel3/actions
}


bootable/recovery/extendedcommands.c:static const char *SDCARD_UPDATE_FILE = "/sdcard/update.zip";
bootable/recovery/extendedcommands.c:                                    "apply /sdcard/update.zip",
bootable/recovery/extendedcommands.c:                if (confirm_selection("Confirm install?", "Yes - Install /sdcard/update.zip"))
bootable/recovery/install.c:            ui_print("Please switch to Edify scripting (updater-script and update-binary) to create working update zip packages.\n");
bootable/recovery/killrecovery.sh:rm /cache/update.zip
bootable/recovery/minadbd/adb.h:#define ADB_SIDELOAD_FILENAME "/tmp/update.zip"
bootable/recovery/recovery.c:static const char *SDCARD_PACKAGE_FILE = "/sdcard/update.zip";
build/core/Makefile:INSTALLED_RECOVERYZIP_TARGET := $(PRODUCT_OUT)/utilities/update.zip
build/tools/device/makerecoveries.sh:    mcpguard $OUT/utilities/update.zip recoveries/recovery-clockwork-$RELEASE_VERSION-$DEVICE_NAME.zip
build/tools/device/mkrecoveryzip.sh:rm -f $UTILITIES_DIR/update.zip
build/tools/device/mkrecoveryzip.sh:java -jar $SIGNAPK -w $ANDROID_BUILD_TOP/build/target/product/security/testkey.x509.pem $ANDROID_BUILD_TOP/build/target/product/security/testkey.pk8 $UTILITIES_DIR/unsigned.zip $UTILITIES_DIR/update.zip
build/tools/device/mkrecoveryzip.sh:echo Recovery FakeFlash is now available at $OUT/utilities/update.zip

system/core/fastboot/fastboot.c:            "  update <filename>                        reflash device from update.zip\n"
system/core/fastboot/fastboot.c:                do_update("update.zip", erase_first);

sed -i \
    -e s/DEBUG_LOG=.*/DEBUG_LOG=1/g \
    -e s/HP_VOLUME=.*/HP_VOLUME=20/g \
    -e s/SP_VOLUME=.*/SP_VOLUME=20/g \
    /data/config.txt

sed -i \
    -e s/logger=.*/logger=on/g \
    -e s/vmtweaks=.*/vmtweaks=disable/g \
    -e s/sound_volume1=.*/sound_volume1=20/g \
    -e s/sound_volume3=.*/sound_volume3=20/g \
    /data/.[ks]*/*.profile

#!/bin/bash

old=$(ls --ignore=*$(date -u +%m%d)* --ignore=cm-installer* --ignore=gapps* $*)
echo $old
mv $old /home/frs/project/cm10i9100vsync/old/

$(date -u +%m%d)


make -C kernel/samsung/smdk4210 O=/home/changmin/android/system_mr1/out/target/product/i9100/obj/KERNEL_OBJ ARCH=arm CROSS_COMPILE=" /home/changmin/android/system_mr1/prebuilt/linux-x86/toolchain/arm-eabi-4.7/bin/arm-eabi-" headers_install
/home/changmin/android/system_mr1/prebuilt/linux-x86/toolchain/arm-eabi-4.7/bin/arm-eabi-gcc -version



-# CONFIG_NFC_DEVICES is not set
+CONFIG_NFC_DEVICES=y
+CONFIG_PN544_NFC=y
+# CONFIG_PN65N_NFC is not set

$ grep 544 u1_kor_skt_defconfig 
CONFIG_PN544=y

$ grep DMB u1_kor_skt_defconfig 
CONFIG_TDMB=y
CONFIG_TDMB_SPI=y
CONFIG_TDMB_VENDOR_INC=y
CONFIG_TDMB_T3900=y
CONFIG_TDMB_VENDOR_TELECHIPS=y
CONFIG_TDMB_TCC3170=y

$ grep TUNER u1_kor_skt_defconfig 
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y



adbroot pm clear com.android.gallery3d
adbroot pm clear com.android.providers.media

external/chromium/android/prefix.h:76:0: warning: "_POSIX_MONOTONIC_CLOCK" redefined [enabled by default]
bionic/libc/include/sys/limits.h:173:0: note: this is the location of the previous definition

em external/chromium/android/prefix.h
em bionic/libc/include/sys/limits.h
