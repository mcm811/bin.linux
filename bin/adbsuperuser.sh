adb root
adb remount
adb push ~/android/superuser/system/app/Superuser.apk /system/app
adb shell chmod 644 /system/app/Superuser.apk
