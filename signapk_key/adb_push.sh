#!/bin/sh
PATCH="Android/android_patch"
TARGET=""
[ -z $(adb shell "ls -d /emmc/$PATCH 2> /dev/null") ] || TARGET="/emmc/$PATCH"
[ -z $(adb shell "ls -d /sdcard/$PATCH 2> /dev/null") ] || TARGET="/sdcard/$PATCH"
[ -z $TARGET ] && echo "NO TARGET" && exit 1 || echo $TARGET

echo "adb push cm9-korean-v2_signed.zip $TARGET/cm9-korean-v2_signed.zip"
adb push cm9-korean-v2_signed.zip $TARGET/cm9-korean-v2_signed.zip
