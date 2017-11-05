#!/bin/bash

if ! [ -e .repo ]; then
	echo "change to build directory"
	exit
fi

grep -e 4.7 -e 4.6 -e arm-eabi build/envsetup.sh
cm;. build/envsetup.sh;lunch cm_i9100-userdebug

echo "make Apollo"
echo "make Settings"
echo "make Superuser"
echo "make hwcomposer.exynos4"
exit

mov_hysti()
{
    cm;. build/envsetup.sh;lunch cm_i9100-userdebug

    cm;cd out;findname mxt224_u1*
    cm;rm /out/target/product/i9100/obj/KERNEL_OBJ/drivers/input/touchscreen/mxt224_u1.o
    cm;./cmb kernel
    cm;adbpush out/target/product/i9100/kernel-cm-10-20121004-i9100-jbmali-oshwc2-vsync_sysfs-changmin-signed.zip
    adbkernel

    cat /sys/bus/i2c/devices/3-004a/mov_hysti
    adb shell "cat /sys/bus/i2c/devices/3-004a/mov_hysti"

    echo "1" > /sys/bus/i2c/devices/3-004a/mov_hysti
}

apollo_vsync()
{
    vsync;cd out/target/product/i9100
    7z u cm-10-20120929-EXPERIMENTAL-i9100-vsync-changmin.zip system/app/Apollo.apk
    7z l cm-10-20120929-EXPERIMENTAL-i9100-vsync-changmin.zip system/app/Apollo.apk
    adb root
    adb remount
    adb push system/app/Apollo.apk system/app
    adb shell chmod 644 system/app/Apollo.apk
}

apollo_jmmali()
{
    jbmali;cd out/target/product/i9100
    7z u cm-10-20120929-EXPERIMENTAL-i9100-jb_mali-changmin.zip system/app/Apollo.apk
    7z l cm-10-20120929-EXPERIMENTAL-i9100-jb_mali-changmin.zip system/app/Apollo.apk
    adb root
    adb remount
    adb push system/app/Apollo.apk system/app
    adb shell chmod 644 system/app/Apollo.apk
}

kernel()
{
    cm;. build/envsetup.sh;lunch cm_i9100-userdebug

    cm;./cmb kernelclean
    adb root;adb shell

    cm;./cmb kernel
    cm;adbpush out/target/product/i9100/kernel-cm-10-20121004-i9100-jbmali-oshwc2-vsync_sysfs-changmin-signed.zip
    adbkernel

    vi /sys/devices/platform/samsung-pd.2/s3cfb.0/vsync_time

    adb shell "cat /sys/class/misc/gpu_clock_control/gpu_control /sys/class/misc/gpu_voltage_control/gpu_control /sys/class/misc/gpu_clock_control/gpu_staycount"
    adb shell "cat /sys/module/mali/parameters/mali_gpu_clk /sys/module/mali/parameters/mali_gpu_vol"
    adb shell "watch -n 1 cat /sys/module/mali/parameters/mali_gpu_clk /sys/module/mali/parameters/mali_gpu_vol"
}

frameworks_base() {
    cm;. build/envsetup.sh;lunch cm_i9100-userdebug
    cm;make frameworks/base
}

adb logcat *:E

cm;cd out;findexec hwcomposer* "rm -rf";findexec SecHWC* "rm -rf";cm;make hwcomposer.exynos4;
adb root;sleep 3;adb remount;
adb push out/target/product/i9100/system/lib/hw/hwcomposer.exynos4.so /system/lib/hw/
adb reboot

echo "0" > /sys/module/mali/parameters/mali_touch_boost_level
echo "267 160 200 267" > /sys/class/misc/gpu_clock_control/gpu_control
echo "1000000 950000 1000000 1050000" > /sys/class/misc/gpu_voltage_control/gpu_control
echo "70% 50% 85% 50% 85% 70%" > /sys/class/misc/gpu_clock_control/gpu_control

####################################################################################################

cd ~/download/mr1
cp ~/download/vsync_sysfs/system/lib/hw/hwcomposer.exynos4.so system/lib/hw/hwcomposer.exynos4.so
7z u cm-10-20121205-EXPERIMENTAL-i9100-vsync_sysfs-changmin.zip system/lib/hw/hwcomposer.exynos4.so

hwcomposer.exynos4()
{
    # cm;. build/envsetup.sh;lunch cm_i9100-userdebug
    cmsetup
    # cm;findrm out hwcomposer*;findrm out SecHWC*;make hwcomposer.exynos4
    mkhwc

    if [ -n "$(adb shell "uname -a | grep CM")" ]; then
        # cm10
	adb root;sleep 3;adb remount;
	adb push out/target/product/i9100/system/lib/hw/hwcomposer.exynos4.so /system/lib/hw/
	adb reboot
    else
        # siyah
	adb root;sleep 3;adb remount; adb shell su -c "mount -o remount,rw /system";
	adb push out/target/product/i9100/system/lib/hw/hwcomposer.exynos4.so /sdcard/Download/;adb shell su -c "mv /sdcard/Download/hwcomposer.exynos4.so /system/lib/hw/;chmod 644 /system/lib/hw/hwcomposer.exynos4.so"
	adb reboot
    fi
}

gralloc.exynos4()
{
    # cm;. build/envsetup.sh;lunch cm_i9100-userdebug
    cmsetup
    # cm;findrm out gralloc*;make gralloc.exynos4
    mkgra

    if [ -n "$(adb shell "uname -a | grep CM")" ]; then
        # cm10
	adb root;sleep 3;adb remount;
	adb push out/target/product/i9100/system/lib/hw/gralloc.default.so /system/lib/hw/
	adb push out/target/product/i9100/system/lib/hw/gralloc.exynos4.so /system/lib/hw/
	adb reboot
    else
        # siyah
	adb root;sleep 3;adb remount; adb shell su -c "mount -o remount,rw /system";
	adb push out/target/product/i9100/system/lib/hw/gralloc.default.so /sdcard/Download/;adb shell su -c "mv /sdcard/Download/gralloc.default.so /system/lib/hw/;chmod 644 /system/lib/hw/gralloc.default.so"
	adb push out/target/product/i9100/system/lib/hw/gralloc.exynos4.so /sdcard/Download/;adb shell su -c "mv /sdcard/Download/gralloc.exynos4.so /system/lib/hw/;chmod 644 /system/lib/hw/gralloc.exynos4.so"
	adb reboot
    fi
}

echo cmsetup
echo mkhwc
echo mkgra

make out/target/product/i9100/system/lib/libsqlite.so

nfc() {
    cm;em device/samsung/i9100/cm.mk
# Enhanced NFC
$(call inherit-product, vendor/cm/config/nfc_enhanced.mk)

    cm;em device/samsung/galaxys2-common/common.mk
# NFC
PRODUCT_PACKAGES += \
    nfc.exynos4 \
    libnfc \
    libnfc_jni \
    Nfc \
    Tag

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
    device/samsung/galaxys2-common/configs/nfcee_access.xml:system/etc/nfcee_access.xml \
    vendor/samsung/galaxys2-common/proprietary/system/lib/hw/nfc.exynos4.so:system/lib/hw/nfc.exynos4.so
}

nfc_work() {
vendor/cm/config/nfc_enhanced.mk
vendor/cm/config/permissions/com.cyanogenmod.nfc.enhanced.xml
vendor/cm/config/permissions/com.cyanogenmod.nfc.enhanced.xml:system/etc/permissions/com.cyanogenmod.nfc.enhanced.xml

frameworks/native/data/etc/android.hardware.nfc.xml
frameworks/native/data/etc/com.android.nfc_extras.xml

system/lib/libnfc.so
system/lib/libnfc_jni.so
system/lib/libnfc_ndef.so
system/lib/hw/nfc.exynos4.so

system/app/Tag.apk
system/app/Nfc.apk

frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml
frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml
device/samsung/galaxys2-common/configs/nfcee_access.xml:system/etc/nfcee_access.xml
}

nfc_remove() {
    if [ -f /system/app/Nfc.apk ]; then
	mount -o remount,rw /system
	rm /system/etc/permissions/android.hardware.nfc.xml \
	    /system/etc/permissions/com.android.nfc_extras.xml \
	    /system/etc/nfcee_access.xml \
	    /system/lib/libnfc.so \
	    /system/lib/libnfc_jni.so \
	    /system/lib/libnfc_ndef.so \
	    /system/lib/hw/nfc.exynos4.so \
	    /system/app/Tag.apk \
	    /system/app/Nfc.apk
	mount -o remount,ro /system
    fi
}
