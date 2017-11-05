##################################################
# kernel_update.sh
# 2012.8.9 <changmin811@gmail.com>
##################################################

TARGET="~changmin/ramdisk"

cd ~changmin/download
FILES=$(ls -t Siyah* *Kernel* 2> /dev/null)
for FILE in $FILES; do
    eval "$(echo $FILE | sed -nre 's/.*[.](...)/FILE_TYPE="\1";/p' -)"
    if [ $FILE_TYPE == "zip" ]; then
        echo -n "$FILE "
		7z e -yo$TARGET $FILE zImage boot/zImage boot.img boot/boot.img
                break 
    elif [ $FILE_TYPE == "tar" ]; then
        echo -n "$FILE "
        tar xvf $FILE -C $TARGET zImage boot/zImage boot.img boot/boot.img
                break
    fi
done

if [ -f $TARGET/zImage ]; then
	echo $TARGET/zImage
	mv $TARGET/zImage $TARGET/boot.img
fi

if [ -f $TARGET/boot.img ]; then
	FILES=$(ls -t *cm-*.zip 2> /dev/null)
	for FILE in $FILES; do
		if [ -f "$FILE" ]; then
            mv $TARGET/boot.img boot.img
			echo $FILE
			7z d -y $FILE boot.img system/app/TvOut.apk
			7z u -y $FILE boot.img
			rm boot.img
			7z l $FILE boot.img
#			scp $FILE root@sgs2:/storage/sdcard0/Download/
			adb push $FILE /storage/sdcard0/Download/
			break;
		fi
	done
fi
