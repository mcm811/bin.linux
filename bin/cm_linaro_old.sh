#!/bin/bash

arm_eabi_link()
{
    return 0

    rm -f out; ln -sf ../out-hdd-vsync out; ls -l out
    rm -f arm-eabi-4.7 arm-eabi-4.6;ln -s prebuilts/gcc/linux-x86/arm/arm-eabi-4.7 .

    rm prebuilts/gcc/linux-x86/arm/arm-eabi-4.7
    ln -s /home/changmin/android/android-toolchain-eabi prebuilts/gcc/linux-x86/arm/arm-eabi-4.7

    rm prebuilt/linux-x86/toolchain/arm-eabi-4.7
    ln -s /home/changmin/android/android-toolchain-eabi prebuilt/linux-x86/toolchain/arm-eabi-4.7
}

arm_eabi_4.7()
{
    sed -i -e 's/4.6/4.7/g' build/envsetup.sh
    grep -e 4.7 -e 4.6 -e arm-eabi build/envsetup.sh

    sed -i -e 's/arm-eabi-4.4.3/arm-eabi-4.7/g' \
	device/samsung/galaxys2-common/BoardCommonConfig.mk
    grep -e 4.7 -e 4.6 -e arm-eabi device/samsung/galaxys2-common/BoardCommonConfig.mk
}

change_to_changmin()
{
    sed --follow-symlinks -i \
	-e 's/jbmali-oshwc2-vsync_sysfs-changmin/changmin/g' \
	-e 's/vsync_sysfs-changmin/changmin/g' \
	-e 's/notehwc-changmin/changmin/g' \
	-e 's/oshwc2-vsync_ioctl-changmin/changmin/g' \
	-e 's/vsync_ioctl-changmin/changmin/g' \
	-e 's/vsync_sysfs/changmin/g' \
	vendor/cm/config/common.mk
    sed --follow-symlinks -i \
	-e 's/jbmali-oshwc2-vsync_sysfs-changmin/changmin/g' \
	-e 's/vsync_sysfs-changmin/changmin/g' \
	-e 's/notehwc-changmin/changmin/g' \
	-e 's/oshwc2-vsync_ioctl-changmin/changmin/g' \
	-e 's/vsync_ioctl-changmin/changmin/g' \
	-e 's/vsync_sysfs/changmin/g' \
	buildscripts/build.sh
    sed --follow-symlinks -i \
	-e 's/-CM-jbmali-vsync_sysfs/-CM/g' \
	-e 's/-CM-vsync_sysfs-changmin/-CM/g' \
	-e 's/-CM-changmin/-CM/g' \
	-e 's/-CM-vsync_ioctl-changmin/-CM/g' \
	-e 's/-CM-vsync_ioctl/-CM/g' \
	-e 's/-CM-vsync_sysfs/-CM/g' \
	kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
}

SYNC_ON_DEFCONFIG() {
    sed --follow-symlinks -i \
	-e 's/# CONFIG_SYNC is not set.*/CONFIG_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC is not set.*/CONFIG_SW_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC_USER is not set.*/CONFIG_SW_SYNC_USER=y/g' \
	defconfig
    grep -e CONFIG_SYNC -e CONFIG_SW_SYNC -e CONFIG_SW_SYNC_USER defconfig
    [ -e .config ] && rm .config
}

SYNC_OFF_DEFCONFIG() {
    sed --follow-symlinks -i \
	-e 's/^CONFIG_SYNC=y.*/# CONFIG_SYNC is not set/g' \
	-e 's/^CONFIG_SW_SYNC=y.*/# CONFIG_SW_SYNC is not set/g' \
	-e 's/^CONFIG_SW_SYNC_USER=y.*/# CONFIG_SW_SYNC_USER is not set/g' \
	defconfig
    grep -e CONFIG_SYNC -e CONFIG_SW_SYNC -e CONFIG_SW_SYNC_USER defconfig
    [ -e .config ] && rm .config
}

change_to_4.7-vsync_ioctl()
{
    if ! [ -e .repo ]; then
	echo "change to build directory"
	exit
    fi

    arm_eabi_link
    arm_eabi_4.7

    if [ "$(grep vsync vendor/cm/config/common.mk)" == "CM_EXTRAVERSION := vsync_ioctl-changmin" ]; then
	echo "vsync_ioctl-changmin: OK"
	return 0
    fi

    change_to_changmin
    sed -i \
	-e 's/changmin/vsync_ioctl-changmin/g' vendor/cm/config/common.mk
    grep changmin vendor/cm/config/common.mk

    sed -i \
	-e 's/changmin/vsync_ioctl-changmin/g' buildscripts/build.sh
    grep changmin buildscripts/build.sh

    sed -i \
	-e 's/-CM/-CM-vsync_ioctl-changmin/g' \
	kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
    grep -e "-CM" kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig

    prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-gcc --version

    rm -f out/target/product/i9100/system/lib/hw/hwcomposer.smdk4210.so
}

change_to_4.7-jbmali-vsync_sysfs()
{
    if ! [ -e .repo ]; then
	echo "change to build directory"
	exit
    fi

    arm_eabi_link
    arm_eabi_4.7

    if [ "$(grep vsync_sysfs vendor/cm/config/common.mk)" == "CM_EXTRAVERSION := vsync_sysfs" ]; then
	echo "vsync_sysfs-changmin: OK"
	return 0
    fi

    change_to_changmin
    sed -i -e 's/changmin/vsync_sysfs/g' vendor/cm/config/common.mk
    grep vsync_sysfs vendor/cm/config/common.mk

    sed -i -e 's/changmin/vsync_sysfs/g' buildscripts/build.sh
    grep vsync_sysfs buildscripts/build.sh

    sed -i -e 's/-CM/-CM-vsync_sysfs/g' \
	kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
    grep -e "-CM" kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig

    # hwc: SecHWC.cpp
    sed -i \
	-e 's/#define NO_HW_VSYNC/#define YES_HW_VSYNC/g' \
	hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp

    # kernel: s3cfb_main.c
    sed -i \
	-e 's/#define USE_VSYNC_MODE USE_VSYNC_OFF/#define USE_VSYNC_MODE USE_VSYNC_SYSFS/g' \
	kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c

    cd kernel/samsung/smdk4210;SYNC_ON_DEFCONFIG;cd -

    prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-gcc --version

    # change to oshwc
    # rm -f out/target/product/i9100/system/lib/hw/hwcomposer.smdk4210.so
    # cd device/samsung/galaxys2-common;git reset --hard d72dd98d09adca065ea65145e38d79d438bf853a;cd -
    # cd vendor/samsung/galaxys2-common;git reset --hard d9ece27d918006d34c4dc3eb7dae24867979ffe9;cd -
}

change_to_4.7-jbmali-vsync_off()
{
    if ! [ -e .repo ]; then
	echo "change to build directory"
	exit
    fi

    arm_eabi_link
    arm_eabi_4.7

    if [ "$(grep notehwc vendor/cm/config/common.mk)" == "CM_EXTRAVERSION := notehwc-changmin" ]; then
	echo "notehwc-changmin: OK"
	return 0
    fi

    change_to_changmin
    sed -i -e 's/changmin/notehwc-changmin/g' vendor/cm/config/common.mk
    grep changmin vendor/cm/config/common.mk

    sed -i -e 's/changmin/notehwc-changmin/g' buildscripts/build.sh
    grep changmin buildscripts/build.sh

    sed -i -e 's/-CM/-CM-changmin/g' \
	kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig
    grep -e "-CM" kernel/samsung/smdk4210/arch/arm/configs/cyanogenmod_i9100_defconfig

    # hwc: SecHWC.cpp
    sed -i \
	-e 's/#define YES_HW_VSYNC/#define NO_HW_VSYNC/g' \
	hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp

    # kernel: s3cfb_main.c
    sed -i \
	-e 's/#define USE_VSYNC_MODE USE_VSYNC_SYSFS/#define USE_VSYNC_MODE USE_VSYNC_OFF/g' \
	kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c

    smdk;SYNC_OFF_DEFCONFIG;cd -

    prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-gcc --version

    # cm;ls -l vendor/samsung/galaxys2-common/proprietary/system/lib/hw/hwcomposer.smdk4210.so
    # -rw-r--r-- 1 changmin changmin  30260 10월 25 03:56 hwcomposer.smdk4210.so
    # change to blobhwc
    rm -f out/target/product/i9100/system/lib/hw/hwcomposer.exynos4.so
    cd device/samsung/galaxys2-common;git revert --no-edit f7b5d9f31c029bb5c50a2b6d6becde59352827dd;cd -
    cd vendor/samsung/galaxys2-common;git revert --no-edit 833fe47b50f54c9fb1a619545c3e9734c46858cf;cd -
}

grep -e 4.7 -e 4.6 -e arm-eabi build/envsetup.sh
grep changmin vendor/cm/config/common.mk buildscripts/build.sh
