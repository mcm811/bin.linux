##################################################
# voku-github.sh
# 2012.9.12 <changmin811@gmail.com>
##################################################

alias em='XMODIFIERS= emacs'

export KERNELDIR=`readlink -f .`
export CROSS_COMPILE=$KERNELDIR/android-toolchain-eabi/bin/arm-eabi-

. ~/kernel/siyah/siyahkernel3/arch/arm/configs/siyah_defconfig

github_login() {
	git config --global user.name "mcm811"
	git config --global user.email "changmin811@gmail.com"
	git config --global credential.helper cache
	git config --global credential.helper 'cache --timeout=3600'
}

install_linaro() {
	cd ~/kernel
	tar xvjf android-toolchain-eabi-linaro-4.7-2012.08-2-2012-08-18_18-53-14-linux-x86.tar.bz2
	if [ -d ~/kernel/siyah/siyahkernel3 ]; then
		cd ~/kernel/siyah/siyahkernel3
		ln -s android-toolchain-eabi .
	fi
}

github_sample() {
# Clone your fork
	git clone https://github.com/gokhanmoral/siyahkernel3.git
# Configure remotes
	cd initramfs3
	git remote add upstream https://github.com/dorimanx/initramfs3.git
	git fetch upstream
# Pull in upstream changes
	git fetch upstream
	git merge upstream/master
# Push commits
	git push origin master
# Create branches
	git branch mybranch
# To switch between branches, use git checkout
	git checkout master
}

siyah_init() {
	cd ~/kernel/voku
	git clone https://github.com/voku/initramfs3.git
	cd ~/kernel/voku/initramfs3
	git remote add voku https://github.com/voku/initramfs3.git
	git fetch voku
	git merge voku/master

	cd ~/kernel/voku
	git clone https://github.com/voku/siyahkernel3.git

	cd ~/kernel/voku/siyahkernel3
	git remote add voku https://github.com/voku/siyahkernel3.git
	git fetch voku
	git merge voku/master-3.0.y

	cd ~/kernel/voku/initramfs3
	git remote rename upstream voku
	git fetch voku
	git merge voku/master

	cd ~/kernel/voku/siyahkernel3
	git remote rename upstream voku
	git fetch voku
	git merge voku/master-3.0.y
}

siyah_initramfs() {
	cd ~/kernel/voku/initramfs3
	cat <<EOF >> sbin/ext/tweaks.sh
# fix crt effect
setprop debug.sf.electron_frames 29
EOF
	em ~/kernel/voku/initramfs3/sbin/ext/tweaks.sh
	em ~/kernel/voku/initramfs3/sbin/ext/cortexbrain-tune.sh 
}

siyah_kernel() {
	cd ~/kernel/voku/siyahkernel3
	git fetch http://r.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4412 refs/changes/12/20212/5 && git cherry-pick FETCH_HEAD
	em drivers/video/samsung/s3cfb.h
	em drivers/video/samsung/s3cfb_ops.c
	em drivers/video/samsung/s3cfb_main.c
	em arch/arm/configs/siyah_defconfig
# CONFIG_COMPACTION_RETRY is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_KSM=y
}

siyah_test() {
	cd ~/kernel/voku/siyahkernel3
	cat drivers/video/samsung/s3cfb.h | grep vsync_thread
	cat drivers/video/samsung/s3cfb_main.c | grep vsync_thread
	cat drivers/video/samsung/s3cfb_ops.c | grep s3cfb_vsync_timestamp_changed
	cat .config | grep -e KSM -e COMPACTION -e MIGRATION
}

siyah_update() {
	# cd ~/kernel/voku/initramfs3
	# git fetch voku
	# git merge voku/master

	cd ~/kernel/voku/siyahkernel3
	git fetch voku
	git merge voku/master-3.0.y
	grep CONFIG_LOCALVERSION= arch/arm/configs/dorimanx_defconfig
}

siyah_build() {
	cd ~/kernel/voku/siyahkernel3
	./build_kernel.sh
}

siyah_pkg() {
	cp cm10-vsync-Siyah-s2-CWM.zip ~/download/cm10-vsync$CONFIG_LOCALVERSION-CWM.zip
	7z u ~/download/cm10-vsync$CONFIG_LOCALVERSION-CWM.zip zImage
	7z l ~/download/cm10-vsync$CONFIG_LOCALVERSION-CWM.zip
}

siyah_adb_upgrade() {
	adb push ~/download/cm10-vsync$CONFIG_LOCALVERSION-CWM.zip /sdcard/Download/
	adb shell su -c "cd /sdcard/Download;. ./kernel_install.sh"
	adb reboot
}

main_run() {
	siyah_update
	siyah_build
	siyah_pkg
	siyah_adb_upgrade
}

main_run
