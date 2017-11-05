alias em='XMODIFIERS= emacs'

github_login() {
	git config --global user.name "mcm811"
	git config --global user.email "changmin811@gmail.com"
	git config --global credential.helper cache
	git config --global credential.helper 'cache --timeout=3600'
}

initramfs3_cmd() {
# Clone your fork
	git clone https://github.com/mcm811/initramfs3-dori.git
# Configure remotes
	cd ~/kernel/dori/initramfs3-dori
	git remote add dori https://github.com/dorimanx/initramfs3.git
	git fetch dori
# Pull in upstream changes
	git fetch dori
	git merge dori/master
# Push commits
	git push origin master
# Create branches
	git branch mybranch
# To switch between branches, use git checkout
	git checkout master
}

kernel_cmd() {
# Clone your fork
	git clone https://github.com/mcm811/Dorimanx-SG2-I9100-Kernel.git siyahkernel3
# Push commits
	cd ~/kernel/dori/siyahkernel3
	git push origin master-samsung
# Create branches
	git branch mybranch
# To switch between branches, use git checkout
	git checkout master-samsung
	git checkout mybranch

# Configure remotes
	cd ~/kernel/dori/siyahkernel3
	git remote add dori https://github.com/dorimanx/Dorimanx-SG2-I9100-Kernel.git
	git remote add voku https://github.com/voku/siyahkernel3.git

# Pull in upstream changes
	cd ~/kernel/voku/siyahkernel3
	git fetch dori
	git merge dori/master-samsung
	git fetch voku
	git merge voku/master-3.0.y
}

enable_ksm() {
	cd ~/kernel/dori/Dorimanx-SG2-I9100-Kernel
	em arch/arm/configs/dorimanx_defconfig
# CONFIG_COMPACTION_RETRY is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_KSM=y
	git commit -a -m "config: Enable KSM support"
	git push origin master-samsung
}

s3cfb_vsync() {
	cd ~/kernel/dori/Dorimanx-SG2-I9100-Kernel
	git fetch http://r.cyanogenmod.com/CyanogenMod/android_kernel_samsung_smdk4412 refs/changes/12/20212/5 && git cherry-pick FETCH_HEAD
	git add drivers/video/samsung/s3cfb_ops.c
	git add drivers/video/samsung/s3cfb_main.c
	git add drivers/video/samsung/s3cfb.h
	git commit -a -m "s3cfb-vsync"
	git push origin master-samsung

	cat ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb.h | grep vsync_thread
	cat ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_main.c | grep vsync_thread
	cat ~/android/system/kernel/samsung/smdk4210/drivers/video/samsung/s3cfb_ops.c | grep s3cfb_vsync_timestamp_changed
}

fix_crteffect() {
	cd ~/kernel/dori/initramfs3-dori
	em sbin/ext/cortexbrain-tune.sh
	git commit -a -m "revert: fix crt effect"
	git push origin master
}

dori_update() {
	cd ~/kernel/dori/siyahkernel3
	git fetch dori
	git merge dori/master-samsung
	git fetch voku
	git merge voku/master-3.0.y

	# git push origin master-samsung
	# cd ~/kernel/dori/initramfs3-dori
	# git fetch upstream
	# git merge upstream/master
	# git push origin master
}
