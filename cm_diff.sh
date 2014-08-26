# config
git config --global user.name "changmin"
git config --global user.email "changmin811@gmail.com"
git config --global core.autocrlf input
git config --global core.safecrlf true
git config --global review.review.cyanogenmod.com.changmin changmin

repo start refs/heads/jellybean .
repo start jellybean
repo branch .

cd ~/android/system/hardware/samsung
repo abandon jellybean .
repo sync .
repo start jellybean .
repo branch .
git fetch http://review.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/25/19925/8 && git checkout FETCH_HEAD
repo cherry-pick aefa816917abf737f7c82f3e862ed67866a02b9d

git fetch http://review.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/25/19925/8 && git checkout FETCH_HEAD

git fetch http://review.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/25/19925/8 && git cherry-pick FETCH_HEAD

diff -urw exynos4 ~/doc/hwc_old/exynos4 > ~/exynos4.diff
patch -p0 < ~/exynos4.diff

patch ~/android/system/hardware/samsung/exynos4/hal/include/s3c_lcd.h ~/doc/hwc1.diff
patch ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/Android.mk ~/doc/hwc2.diff
patch ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp ~/doc/hwc3.diff
patch ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWCUtils.h ~/doc/hwc4.diff

git add -A
#git commit --amend
git commit -s
###################################################
exynos4: Implement custom VSYNC IOCTL

* Replace crespo-based VSYNC uevent mechanism in hwcomposer
  with a custom IOCTL mechanism instead (required kernel
  modifications.

* The VSYNC uevents were spamming the Android UEventObserver
  and causing about 7% of constant CPU load
###################################################

repo upload .

diff() {
    cd ~/android/system/kernel/samsung/smdk4210
    repo abandon jellybean .
    repo sync .
    repo start jellybean .
    diff -urw drivers ~/android/mcm811/android_kernel_samsung_smdk4210 > ~/doc/sdmk4210_drivers.diff

    patch -p0 <  ~/doc/sdmk4210_drivers.diff

    # diff -u ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb.h ~/doc/smdk4210/drivers/video/samsung/s3cfb.h                   > ~/doc/ioctl_vsync1.diff
    # diff -u ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c ~/doc/smdk4210/drivers/video/samsung/s3cfb_main.c    > ~/doc/ioctl_vsync2.diff
    # diff -u ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_ops.c ~/doc/smdk4210/drivers/video/samsung/s3cfb_ops.c        > ~/doc/ioctl_vsync3.diff

    cd ~/android/system/hardware/samsung
    repo abandon jellybean .
    repo sync .
    repo start jellybean .
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/25/19925/8 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/17/20617/10 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/41/21541/1 && git cherry-pick FETCH_HEAD

    cd ~/android/system/hardware/samsung
    diff -ur exynos4 ~/doc/exynos4 > ~/doc/exynos4.diff
    patch -p0 < ~/doc/exynos4.diff

    # diff -u exynos4/hal/include/s3c_lcd.h ~/doc/exynos4/hal/include/s3c_lcd.h               		                  > ~/doc/hwc1.diff
    # diff -u exynos4/hal/libhwcomposer/Android.mk ~/doc/exynos4/hal/libhwcomposer/Android.mk                   > ~/doc/hwc2.diff
    # diff -u exynos4/hal/libhwcomposer/SecHWC.cpp ~/doc/exynos4/hal/libhwcomposer/SecHWC.cpp                > ~/doc/hwc3.diff
    # diff -u exynos4/hal/libhwcomposer/SecHWCUtils.h ~/doc/exynos4/hal/libhwcomposer/SecHWCUtils.h          > ~/doc/hwc4.diff

    git add --all
    git commit --amend
    git commit -s
    repo upload .
}

backup() {
    cp ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb.h ~/doc/smdk4210/drivers/video/samsung/
    cp ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c ~/doc/smdk4210/drivers/video/samsung/
    cp ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_ops.c ~/doc/smdk4210/drivers/video/samsung/

    cp ~/android/system/hardware/samsung/exynos4/hal/include/s3c_lcd.h ~/doc/exynos4/hal/include/
    cp ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/Android.mk ~/doc/exynos4/hal/libhwcomposer/
    cp  ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp ~/doc/exynos4/hal/libhwcomposer/
    cp  ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWCUtils.h ~/doc/exynos4/hal/libhwcomposer/
}

patch() {
    patch ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb.h          ~/doc/ioctl_vsync1.diff
    patch ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c   ~/doc/ioctl_vsync2.diff
    patch ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_ops.c     ~/doc/ioctl_vsync3.diff
    patch ~/android/system/hardware/samsung/exynos4/hal/include/s3c_lcd.h ~/doc/hwc1.diff
    patch ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/Android.mk ~/doc/hwc2.diff
    patch ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWC.cpp ~/doc/hwc3.diff
    patch ~/android/system/hardware/samsung/exynos4/hal/libhwcomposer/SecHWCUtils.h ~/doc/hwc4.diff
}

commit() {
##########
    cd ~/android/system/kernel/samsung/smdk4210
    git add -A
    git commit -s
    cat <<EOF
Replace VSYNC uevent thread with a custom IOCTL.

* The uevents were causing high CPU usage in android
  system_server for really no good reason since it
  doesn't need to watch for them
EOF
    repo upload
##########
    cd ~/android/system/hardware/samsung
    git add -A
    git commit -s
    cat <<EOF
exynos4: Implement custom VSYNC IOCTL

* Replace crespo-based VSYNC uevent mechanism in hwcomposer
  with a custom IOCTL mechanism instead (required kernel
  modifications.

* The VSYNC uevents were spamming the Android UEventObserver
  and causing about 7% of constant CPU load
EOF
    repo upload .
}


old_diff() {
    cd ~/android/system/kernel/samsung/smdk4210
    repo abandon jellybean .
    repo sync .
    repo start jellybean .
    diff -urw drivers ~/android/mcm811/android_kernel_samsung_smdk4210/drivers > ~/drivers.diff
    patch -p0 < ~/drivers.diff

    diff -u ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb.h ~/doc/smdk4210/drivers/video/samsung/s3cfb.h                   > ~/doc/ioctl_vsync1.diff
    diff -u ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c ~/doc/smdk4210/drivers/video/samsung/s3cfb_main.c    > ~/doc/ioctl_vsync2.diff
    diff -u ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_ops.c ~/doc/smdk4210/drivers/video/samsung/s3cfb_ops.c        > ~/doc/ioctl_vsync3.diff

    cd ~/android/system/hardware/samsung
    repo abandon jellybean .
    repo sync .
    repo start jellybean .
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/25/19925/8 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/17/20617/10 && git cherry-pick FETCH_HEAD
    git fetch http://r.cyanogenmod.com/CyanogenMod/android_hardware_samsung refs/changes/41/21541/1 && git cherry-pick FETCH_HEAD

    diff -u exynos4/hal/include/s3c_lcd.h ~/doc/exynos4/hal/include/s3c_lcd.h               		                  > ~/doc/hwc1.diff
    diff -u exynos4/hal/libhwcomposer/Android.mk ~/doc/exynos4/hal/libhwcomposer/Android.mk                   > ~/doc/hwc2.diff
    diff -u exynos4/hal/libhwcomposer/SecHWC.cpp ~/doc/exynos4/hal/libhwcomposer/SecHWC.cpp                > ~/doc/hwc3.diff
    diff -u exynos4/hal/libhwcomposer/SecHWCUtils.h ~/doc/exynos4/hal/libhwcomposer/SecHWCUtils.h          > ~/doc/hwc4.diff

    git add --all
    git commit --amend
    git commit -s
    repo upload .
}

bugreporting() {
setting the object to null (gc)

cd ~/android/system/frameworks/base
1185
em packages/SystemUI/src/com/android/systemui/statusbar/phone/PhoneStatusBar.java
flagdbg = null

1690
em services/java/com/android/server/InputMethodManagerService.java
cs = null;

}