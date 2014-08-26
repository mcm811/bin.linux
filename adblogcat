#!/bin/bash

adb_dev() {
    ADB_DEV_NUM=0
    for dev in $(adb devices|grep -v List|awk '{ print $1 }'); do
	echo "export ANDROID_SERIAL=$dev"
	echo "adb -s $dev"
	ADB_DEV_NUM=$(($ADB_DEV_NUM+1))
    done
}

for (( ; ; )); do
    if [ "$(adb get-state)" = "device" ]; then
	adb logcat $*
    fi
    adb_dev
    # if [ "$ADB_DEV_NUM" -ge "2" ]; then
    # 	export ANDROID_SERIAL=0123456789ABCDEF
    # 	continue
    # fi
    sleep 3
    echo
done
