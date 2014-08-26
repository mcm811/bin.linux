##################################################
# kernel_update.sh
# 2012.8.9 <changmin811@gmail.com>
##################################################

cd ~changmin/download
FILES=$(ls -t *cm-*.zip 2> /dev/null)
for FILE in $FILES; do
	if [ -f "$FILE" ]; then
		7z l $FILE boot.img system/app/TvOut.apk
		7z d -y $FILE boot.img system/app/TvOut.apk
		7z l $FILE boot.img system/app/TvOut.apk
#		scp $FILE root@sgs2:/storage/sdcard0/Download/
		adb push $FILE /storage/sdcard0/Download/
		break;
	fi
done
