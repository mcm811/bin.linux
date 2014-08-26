#!/bin/sh

cmreset()
{
    git commit -a -m "abandon"
    repo abandon jellybean .
    repo sync .
    repo start jellybean .
    repo branch .
}

##=====================================================================
## Cherry-pick lists 
##=====================================================================

cm_init.d()
{
    em vendor/cm/prebuilt/common/etc/init.d/20tweaks
    em vendor/cm/config/common.mk
	# tweakinit support
	    # PRODUCT_COPY_FILES += \
	    # vendor/cm/prebuilt/common/etc/init.d/20tweaks:system/etc/init.d/20tweaks \
	    # vendor/cm/prebuilt/common/bin/remount:system/bin/remount
}

cm_jpeg-turbo()
{
    echo -n
    cm;em .repo/local_manifest.xml
}

cm_bionic()
{
    # jb_mail 빌드에 적용하면 카메라 사용시 메모리 충돌 발생!!
    # bionic: Add ARMv7 optimized string handling routines
    # Fix assembler error using newer toolchains. (camera broken)
    # cm;cd bionic
    # cmreset
    # git fetch http://review.cyanogenmod.com/CyanogenMod/android_bionic refs/changes/35/17535/2 && git cherry-pick FETCH_HEAD
    # git fetch http://review.cyanogenmod.com/CyanogenMod/android_bionic refs/changes/39/20839/1 && git cherry-pick FETCH_HEAD
    # git fetch http://review.cyanogenmod.com/CyanogenMod/android_bionic refs/changes/67/24967/2 && git cherry-pick FETCH_HEAD
}

cm_libpixelflinger()
{
    # libpixelflinger: Include NEON optimized assembly
    # libpixelflinger: Add ARM NEON optimized scanline_t32cb16 (This can dramatically improve the performance of boot animation.)
    # cm;cd system/core
    # cmreset
    # git fetch http://review.cyanogenmod.com/CyanogenMod/android_system_core refs/changes/51/17551/7 && git cherry-pick FETCH_HEAD
    # git fetch http://review.cyanogenmod.com/CyanogenMod/android_system_core refs/changes/52/17552/5 && git cherry-pick FETCH_HEAD
}

cm_libcore()
{
## Fix a native memory leak in SimpleDateFormat cloning. (*)
    cm;cd libcore
    cmreset
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_libcore refs/changes/01/24001/1 && git cherry-pick FETCH_HEAD
}

cm_cherry_pick_rom()
{
    cm;cd frameworks/base
    cmreset
# Add surfaceflinger_client stub
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/91/21391/2 && git cherry-pick FETCH_HEAD
# Status bar: Center clock 1/2
    #git fetch http://r.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/68/22968/2 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/94/19894/7 && git cherry-pick FETCH_HEAD
## Fix/workaround RILJ wakelock on Smdk4210Ril (*)
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/42/23242/1 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/42/23242/2 && git cherry-pick FETCH_HEAD
## Smdk4210RIL: handle voice tech request, block cdma subscruption source request (*)
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/93/23993/1 && git cherry-pick FETCH_HEAD
    cm;cd frameworks/base
#Improve scan time for some cases
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/62/27862/1 && git cherry-pick FETCH_HEAD

    cm;cd external/dnsmasq
    cmreset
## fix memory leaking (http://review.cyanogenmod.com/#/c/23578/)
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_external_dnsmasq refs/changes/78/23578/1 && git cherry-pick FETCH_HEAD

    cm;cd packages/apps/Settings
    cmreset
## Status bar: Center clock
    #git fetch http://r.cyanogenmod.com/CyanogenMod/android_packages_apps_Settings refs/changes/67/22967/2 && git cherry-pick FETCH_HEAD
    #git fetch http://r.cyanogenmod.com/CyanogenMod/android_packages_apps_Settings refs/changes/41/19941/6 && git cherry-pick FETCH_HEAD

    # set the object to null (The garbage collector to release memory)
    cm;cd frameworks/base
    cmreset
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/76/23676/1 && git cherry-pick FETCH_HEAD
    # em ~/android/system/frameworks/base/services/java/com/android/server/InputMethodManagerService.java #:1684:
    # em ~/android/system/frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/PhoneStatusBar.java #:1166:
}

cm_applo()
{
    cm;cd packages/apps/Apollo
## Applo: Rewrite image fetching and caching
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_packages_apps_Apollo refs/changes/76/24076/1 && git cherry-pick FETCH_HEAD
}

cm_navibar()
{
    cm;cd frameworks/base
# Navigation bar: Ability to enable on every device 1/2
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/26/20726/8 && git cherry-pick FETCH_HEAD

## Navigation bar(softkey): Ability to enable on every device
    cm;cd packages/apps/Settings
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_packages_apps_Settings refs/changes/27/20727/9 && git cherry-pick FETCH_HEAD
    # em res/xml/system_settings.xml 웹페이지 보고 수작업으로 추가하고 ammend 해주면 됨
}

cm_smdk4210()
{
    cm;cd kernel/samsung/smdk4210
    cmreset
# exynos4 s3cfb: Replace VSYNC uevent thread with a custom IOCTL (http://review.cyanogenmod.com/#/c/23403/)
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4210 refs/changes/53/23653/1 && git cherry-pick FETCH_HEAD
# exynos4 s3cfb: Don't lock for vsync poll (http://review.cyanogenmod.com/#/c/23634/1)
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4210 refs/changes/55/23655/1 && git cherry-pick FETCH_HEAD    
}

cm_hardware_samsung()
{
    cm;cd hardware/samsung
    cmreset
# exynos4 hwcomposer updated to match new api version 3 (http://review.cyanogenmod.com/#/c/19925/)
# exynos4 fimc, hdmi, hwconverter, fimg4x modify to work with samsungs proprietary cam hal (http://review.cyanogenmod.com/#/c/20617/10)
# exynos4 camera updated to match new api version 3 (http://review.cyanogenmod.com/#/c/21541/)
# exynos4 Implement custom VSYNC IOCTL (http://review.cyanogenmod.com/#/c/23406/1)
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/25/19925/10 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/17/20617/10 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/41/21541/1 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/56/23656/1 && git cherry-pick FETCH_HEAD
#
}

cm_mcm811()
{
    cm;cd kernel/samsung/smdk4210
    cmreset
    git remote add mcm811 https://github.com/mcm811/android_kernel_samsung_smdk4210.git
    git fetch mcm811

    # mali: 4-step mod for GPU (https://github.com/gokhanmoral/siyahkernel3/commit/08c6d67b36c8b452f0619ceb4d528ddefd731f20)
    repo cherry-pick d824f835a4c8fcf4d46da2014d191c3f3523f5e5
    # gpu boost on touch, hardkeys and touchkeys (https://github.com/gokhanmoral/siyahkernel3/commit/9762d6134997f8d4475f83acbd6d0ef32fbbe9ac)
    repo cherry-pick f86d6a9d024ae147b63899a878ed768efd4de59a

    # Replace VSYNC uevent thread with a custom IOCTL.
    repo cherry-pick 737c7db4c9465a06e083577cd2518ed3e29c6dfb

    cm;cd hardware/samsung
    cmreset
    git remote add mcm811 https://github.com/mcm811/android_hardware_samsung.git
    git fetch mcm811
    repo cherry-pick 807cef0bd19717dc5cc5d52b7081ca91c70763fb
    repo cherry-pick 64c0ba73c8d63aaea3b038a8cdaa4732324f02f2
    repo cherry-pick 84fafc3864daf061e5087e7a151fd4bddb1069b3
    repo cherry-pick 170f222f7a0e8b73196e6de0adacfd3f54fb0c2f
}

cm_jb_mali()
{
    export CM_SYSTEM=~/android/devel/
    cm;4210;
## Update mali based on I9305 JB sources
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4210 refs/changes/80/23580/10 && git cherry-pick FETCH_HEAD
## configs: Update i9100/i777/n7000 for r3p0 Mali (patch set 3)
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4210 refs/changes/24/23924/3 && git cherry-pick FETCH_HEAD

    cm;cd device/samsung/galaxys2-common
## Update for JB/Mali r3p0
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_device_samsung_galaxys2-common refs/changes/97/23797/2 && git cherry-pick FETCH_HEAD
}

cm_noscrollcache()
{
# http://forum.xda-developers.com/showthread.php?t=1411317
    cm;cd frameworks/base
    em core/java/android/widget/AbsListView.java
    # createScrollingCache	4879
    # initAbsListView		808
    # setScrollingCacheEnabled	1568
}

cm_audio_effects_conf()
{
    em packages/apps/DSPManager/cyanogen-dsp/audio_effects.conf
    cm; cp packages/apps/DSPManager/cyanogen-dsp/audio_effects.conf \
	frameworks/av/media/libeffects/data/audio_effects.conf

    em frameworks/av/media/libeffects/data/audio_effects.conf
    cm;cd frameworks/av/media/libeffects;gg
}

exit

mali_kernel_utilization()
{
    mali;smdk;em drivers/media/video/samsung/mali/common/mali_kernel_utilization.c
    vs;smdk;em drivers/media/video/samsung/mali/common/mali_kernel_utilization.c
//#define MALI_GPU_UTILIZATION_TIMEOUT 1000
#define MALI_GPU_UTILIZATION_TIMEOUT 100
}

ril()
{
# http://review.cyanogenmod.com/#/c/23993/5/
# ril: block unsupported requests on Smdk4210RIL, add SamsungExynosRIL class for JB rils
    cm;cd frameworks/base;
    em telephony/java/com/android/internal/telephony/RIL.java
    em telephony/java/com/android/internal/telephony/Smdk4210RIL.java
    ls telephony/java/com/android/internal/telephony/SamsungExynosRIL.java

    cp telephony/java/com/android/internal/telephony/RIL.java ~/workspace
    cp telephony/java/com/android/internal/telephony/Smdk4210RIL.java ~/workspace
    
    cp ~/workspace/*java ~/android/system_vsync/frameworks/base/telephony/java/com/android/internal/telephony/
    rm telephony/java/com/android/internal/telephony/SamsungExynosRIL.java


    cm;cd frameworks/base;git grep esponseCellList
}






cm;cd frameworks/base;
em telephony/java/com/android/internal/telephony/RIL.java


import static com.android.internal.telephony.RILConstants.*;
import static android.telephony.TelephonyManager.NETWORK_TYPE_UNKNOWN;
import static android.telephony.TelephonyManager.NETWORK_TYPE_EDGE;
import static android.telephony.TelephonyManager.NETWORK_TYPE_GPRS;
import static android.telephony.TelephonyManager.NETWORK_TYPE_UMTS;
import static android.telephony.TelephonyManager.NETWORK_TYPE_HSDPA;
import static android.telephony.TelephonyManager.NETWORK_TYPE_HSUPA;
import static android.telephony.TelephonyManager.NETWORK_TYPE_HSPA;
///////////////////////
import static android.telephony.TelephonyManager.NETWORK_TYPE_HSPAP;
///////////////////////

    protected Object
    responseCellList(Parcel p) {
       int num, rssi;
       String location;
       ArrayList<NeighboringCellInfo> response;
       NeighboringCellInfo cell;

       num = p.readInt();
       response = new ArrayList<NeighboringCellInfo>();

       // Determine the radio access type
       String radioString = SystemProperties.get(
               TelephonyProperties.PROPERTY_DATA_NETWORK_TYPE, "unknown");
       int radioType;
       if (radioString.equals("GPRS")) {
           radioType = NETWORK_TYPE_GPRS;
       } else if (radioString.equals("EDGE")) {
           radioType = NETWORK_TYPE_EDGE;
       } else if (radioString.equals("UMTS")) {
           radioType = NETWORK_TYPE_UMTS;
       } else if (radioString.equals("HSDPA")) {
           radioType = NETWORK_TYPE_HSDPA;
       } else if (radioString.equals("HSUPA")) {
           radioType = NETWORK_TYPE_HSUPA;
       } else if (radioString.equals("HSPA")) {
           radioType = NETWORK_TYPE_HSPA;
///////////////////////
       } else if (radioString.equals("HSPA+")) {
           radioType = NETWORK_TYPE_HSPAP;
///////////////////////
       } else {
           radioType = NETWORK_TYPE_UNKNOWN;
       }

       // Interpret the location based on radio access type
       if (radioType != NETWORK_TYPE_UNKNOWN) {
           for (int i = 0 ; i < num ; i++) {
               rssi = p.readInt();
               location = p.readString();
               cell = new NeighboringCellInfo(rssi, location, radioType);
               response.add(cell);
           }
       }
       return response;
    }


adb logcat -b radio

D/GSM     ( 2724): [GsmSST] Poll ServiceState done:  oldSS=[0 home SKTelecom SKTelecom 45005  UMTS CSS not supported -1 -1 RoamInd=-1 DefRoamInd=-1 EmergOnly=false] newSS=[0 home SKTelecom SKTelecom 45005  UMTS CSS not supported -1 -1 RoamInd=-1 DefRoamInd=-1 EmergOnly=false] oldGprs=0 newData=0 oldMaxDataCalls=1 mNewMaxDataCalls=1 oldReasonDataDenied=-1 mNewReasonDataDenied=-1 oldType=UMTS newType=UMTS
D/RILJ    ( 2469): [0174]< REQUEST_GET_NEIGHBORING_CELL_IDS error: com.android.internal.telephony.CommandException: REQUEST_NOT_SUPPORTED
D/RILJ    ( 2724): [0800]< REQUEST_GET_NEIGHBORING_CELL_IDS error: com.android.internal.telephony.CommandException: REQUEST_NOT_SUPPORTED
D/RILJ    ( 2724): [0866]< REQUEST_GET_NEIGHBORING_CELL_IDS error: com.android.internal.telephony.CommandException: REQUEST_NOT_SUPPORTED
D/RILJ    ( 2724): [0935]< REQUEST_GET_NEIGHBORING_CELL_IDS error: com.android.internal.telephony.CommandException: REQUEST_NOT_SUPPORTED

cm_noscrollcache()
{
# http://forum.xda-developers.com/showthread.php?t=1411317
    cm;cd frameworks/base
    em core/java/android/widget/AbsListView.java
    # cp core/java/android/widget/AbsListView.java ~/workspace/
    # cp ~/workspace/AbsListView.java core/java/android/widget/AbsListView.java
    # createScrollingCache	4879
    # initAbsListView		808
    # setScrollingCacheEnabled	1568
    # CACHEOFF => true to false
    # CACHEON  => false to true

# REVERT: http://review.cyanogenmod.com/#/c/20117/2/core/java/android/widget/AbsListView.java
# search keyword: isc
# 584
# 814
# 4046
# 4123
# 4133
# 813

cm;cd frameworks/base
em core/java/android/view/ViewConfiguration.java

//  private static final long SEND_RECURRING_ACCESSIBILITY_EVENTS_INTERVAL_MILLIS = 100;
    private static final long SEND_RECURRING_ACCESSIBILITY_EVENTS_INTERVAL_MILLIS = 50;

    private static final int MINIMUM_FLING_VELOCITY = 50;
    private static final int MAXIMUM_FLING_VELOCITY = 8000;

    private static final int MINIMUM_FLING_VELOCITY = 5;
    private static final int MAXIMUM_FLING_VELOCITY = 800;

    private static final int OVERSCROLL_DISTANCE = 500;


em frameworks/base/core/res/res/values/config.xml
}

persist.sys.scrollingcache=3
ro.min.fling_velocity=8000
ro.max.fling_velocity=12000

persist.sys.scrollingcache=0
ro.min.fling_velocity=50
ro.max.fling_velocity=8000

cm_circlemod()
{
cm;cd frameworks/base
#Add CmCircleBattery to StatusBar options (1/2)
git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/36/24736/1 && git cherry-pick FETCH_HEAD

cm;cd packages/apps/Settings
#Add CmCircleBattery to StatusBar options (2/2)
git fetch http://review.cyanogenmod.com/CyanogenMod/android_packages_apps_Settings refs/changes/35/24735/1 && git cherry-pick FETCH_HEAD

}

cm_egl_cache()
{
#Increase EGL blob cache size limits
    cm;cd frameworks/native
# 33 37
    em opengl/libs/EGL/egl_cache.cpp
#define MAX_EGL_CACHE_SIZE (2096 * 1024); // 2mb
#define MAX_EGL_CACHE_SIZE (4096 * 1024); // 4mb
}

#Bugfix: Dock events can have state greater than 1
cm;cd frameworks/base
git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/95/24995/1 && git cherry-pick FETCH_HEAD

# kernel
smdk; git am ~/workspace/0001-samsung_modemctl-fix-crash-on-gcc-4.6.patch


headset_frameworks() {
# EventHub: Modify the keyboard layout file name for headset button
http://review.cyanogenmod.com/#/c/24372/1
# frameworks/base: Add support for wired headset detection
http://review.cyanogenmod.com/#/c/24371/1
# frameworks/base: Fix for UI freeze issue with headset insert/removal
http://review.cyanogenmod.com/#/c/24375/1
# PhoneWindowManager: Release wakelock after headset detection
http://review.cyanogenmod.com/#/c/24374/1
# frameworks/base: Fix for headset switch detect
http://review.cyanogenmod.com/#/c/24373/1

git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/72/24372/1 && git cherry-pick FETCH_HEAD
git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/71/24371/1 && git cherry-pick FETCH_HEAD
git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/75/24375/1 && git cherry-pick FETCH_HEAD
git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/74/24374/1 && git cherry-pick FETCH_HEAD
git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/73/24373/1 && git cherry-pick FETCH_HEAD
}

git format-patch c6df362b8414d71f8f7c4b4e118bb5f7f14f808b..88518ad4cc9e785f92fb56081b93544f3385ee04
0001-Fix-workaround-RILJ-wakelock-on-Smdk4210Ril.patch
0002-fix-conflict.patch
0003-settingsObserver-null.patch
0004-Navigation-Bar-Ability-to-enable-on-every-device-1-2.patch
0005-disable-debug-log.patch
0006-Fix-workaround-RILJ-wakelock-on-Smdk4210Ril.patch
0007-Add-surfaceflinger_client-stub.patch
0008-Smdk4210RIL-handle-voice-tech-request-block-cdma-sub.patch
0009-Disable-ScrollingCache.patch
0010-Smdk4210RIL-block-unsupported-requests-to-avoid-RIL-.patch
0011-add-NETWORK_TYPE_HSPAP.patch
0012-Revert-Improve-scrolling-cache.patch

#headset begin
0013-Bugfix-Dock-events-can-have-state-greater-than-1.patch
0014-EventHub-Modify-the-keyboard-layout-file-name-for-he.patch
0015-frameworks-base-Add-support-for-wired-headset-detect.patch
0016-frameworks-base-Fix-for-UI-freeze-issue-with-headset.patch
0017-PhoneWindowManager-Release-wakelock-after-headset-de.patch
0018-frameworks-base-Fix-for-headset-switch-detect.patch
#headset end

git am ~/workspace/frameworks/*patch

git format-patch d77758449b78055b813d80441c443e6c08a3804a..1fbe6da40125a4675f8eefe175dd5a2465bfbf05
git am /home/changmin/workspace/settings/*patch


soundrecoder()
{
    cd packages/apps/SoundRecorder/
    # restore soundrecorder interface
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_packages_apps_SoundRecorder refs/changes/10/25010/1 && git cherry-pick FETCH_HEAD
}

volume_bug()
{
    # Default device volumes not initialised (http://review.cyanogenmod.com/#/c/25502/)
    cd frameworks/base/
    git fetch http://review.cyanogenmod.com/CyanogenMod/android_frameworks_base refs/changes/02/25502/1 && git cherry-pick FETCH_HEAD
}

#[WIP] mc1n2: Opensource audio HAL from Replicant (http://review.cyanogenmod.org/#/c/26281/) (Patch Set 5)
os_mc1n2() {
    cd vendor/samsung/galaxys2-common
    git am 0001-Remove-closed-source-Yamaha-crap.patch
    cd -
    cd device/samsung/galaxys2-common/
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_device_samsung_galaxys2-common refs/changes/81/26281/5 && git cherry-pick FETCH_HEAD
    cd -

    # system 디렉토리 안에 기존 파일들을 전부 삭제후 빌드해야 롬설치시 오류가 발생하지 않습니다
    mr0clean
    cd out
    rm -rf target/product/i9100/system/*
    findrm *service_manager*
    findrm *main_mediaserver*
    findrm *AudioSystem*
    findrm *AudioFlinger*
    findrm *AudioPolicyService*
    findrm *audio_hw*
    findrm *audio_policy*
    findrm *AudioHardwareInterface*
    findrm *audio_hw_hal*
    findrm *audio_policy_hal*
    cd -
}

os_mc1n2_reset() {
    cm;cd vendor/samsung/galaxys2-common
    #git reset --hard cf95428136c93ae9ca897c06e58264b41df2d8a1
    git revert c9b1fd746a6e1082703b31dff570e234ddc25f7f
    cd -
    cm;cd device/samsung/galaxys2-common/
    #git reset --hard d72dd98d09adca065ea65145e38d79d438bf853a
    git revert 358132e800d295f0bc2a56384a81e71392fde7a7
    cd -

    # system 디렉토리 안에 기존 파일들을 전부 삭제후 빌드해야 롬설치시 오류가 발생하지 않습니다
    mr0clean
    cd out
    rm -rf target/product/i9100/system/*
    findrm *service_manager*
    findrm *main_mediaserver*
    findrm *AudioSystem*
    findrm *AudioFlinger*
    findrm *AudioPolicyService*
    findrm *audio_hw*
    findrm *audio_policy*
    findrm *AudioHardwareInterface*
    findrm *audio_hw_hal*
    findrm *audio_policy_hal*
    cd -
}

eclectronBean() {
    cm;cd frameworks/base
#Electron Beam Animation (1/3 Frameworks-base)
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/26/28126/1 && git cherry-pick FETCH_HEAD
#Improve scan time for some cases
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/62/27862/1 && git cherry-pick FETCH_HEAD

    cm;cd frameworks/native
#Electron Beam Animation (2/3 Frameworks-native)
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/27/28127/2 && git cherry-pick FETCH_HEAD

    cm;cd packages/apps/Settings/
#Electron Beam Animation (2/2 Settings)
    git fetch http://review.cyanogenmod.org/CyanogenMod/android_packages_apps_Settings refs/changes/25/28125/1 && git cherry-pick FETCH_HEAD
}

cm-10.1-samsung_audio() {
    cm;rm -rf out/target/product/i9100/system/*

    cm;cd vendor/samsung/galaxys2-common; repo start cm-10.1-samsung_audio .
    #git revert 7662d7cc88bc30ed231add59dd331708cf95a502
    
    cm;cd device/samsung/galaxys2-common; repo start cm-10.1-samsung_audio .
    #git revert 605c54b82e788adcaef610d2bfbd773394c51e88
    #git revert cdc1a96ac05f2eb3e2fea69aa90a18ae3d5696cd
}

# cm-10
cm-10-opensource_audio() {
    mr0;cd vendor/samsung/galaxys2-common; repo start jb-opensource_audio .
    mr0;cd device/samsung/galaxys2-common; repo start jb-opensource_audio .
}

cm-10-samsung_audio() {
    mr0;cd vendor/samsung/galaxys2-common; repo start jb-samsung_audio .
    mr0;cd device/samsung/galaxys2-common; repo start jb-samsung_audio .
}

# cm-10.1
cm-10.1-opensource_audio() {
    mr1;cd vendor/samsung/galaxys2-common; repo start cm-10.1 .
    mr1;cd device/samsung/galaxys2-common; repo start cm-10.1 .
}

cm-10.1-samsung_audio() {
    mr1;cd vendor/samsung/galaxys2-common; repo start cm-10.1-samsung_audio .
    mr1;cd device/samsung/galaxys2-common; repo start cm-10.1-samsung_audio .

    mr1;em frameworks/base/core/res/res/values/config.xml
    <bool name="config_noDelayInATwoDP">true</bool>
}

remove_audio() {
    cm; rm -rf out/target/product/i9100/system/*
    cd out
    findrm *service_manager*
    findrm *main_mediaserver*
    findrm *AudioSystem*
    findrm *AudioFlinger*
    findrm *AudioPolicyService*
    findrm *audio_hw*
    findrm *audio_policy*
    findrm *AudioHardwareInterface*
    findrm *audio_hw_hal*
    findrm *audio_policy_hal*
    cm
}
