cm_build_init() {
    changmin VsnVJ4QFShDW
    sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev pngcrush schedtool xsltproc
    sudo apt-get install g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline-dev
    mkdir -p ~/bin
    mkdir -p ~/android/system
    curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
    chmod a+x ~/bin/repo
    cd ~/android/system/
    repo init -u git://github.com/CyanogenMod/android.git -b jellybean
    cat <<__EOF__ > ~/android/system/.repo/local_manifest.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="teamhacksung/buildscripts" path="buildscripts" remote="github" revision="jellybean">
    <copyfile dest="build.sh" src="samsung/build.sh" />
  </project>
  <project name="CyanogenMod/android_device_samsung_i9100" path="device/samsung/i9100" remote="github" revision="jellybean" />
  <project name="CyanogenMod/android_device_samsung_galaxys2-common" path="device/samsung/galaxys2-common" remote="github" revision="jellybean" />
  <project name="CyanogenMod/android_kernel_samsung_smdk4210" path="kernel/samsung/smdk4210" remote="github" revision="jellybean" />
  <project name="CyanogenMod/android_hardware_samsung" path="hardware/samsung" remote="github" revision="jellybean" />
  <project name="CyanogenMod/android_packages_apps_SamsungServiceMode" path="packages/apps/SamsungServiceMode" remote="github" revision="jellybean" />
  <project name="TheMuppets/proprietary_vendor_samsung" path="vendor/samsung" remote="github" revision="jellybean" />
</manifest>
__EOF__
    cd ~/android/system/
    repo sync -j16
    . build/envsetup.sh
    lunch cm_i9100-userdebug
    cd ~/android/system/device/samsung/i9100/
    ./proprietary-files.sh
}
