sync_verbose() {
    [ -e .config ] && rm .config
    grep -e CONFIG_SYNC -e CONFIG_SW_SYNC -e CONFIG_SW_SYNC_USER defconfig
    grep "#define USE_VSYNC_MODE" drivers/video/samsung/s3cfb_main.c
}

sync_on() {
    sed --follow-symlinks -i \
	-e 's/# CONFIG_SYNC is not set.*/CONFIG_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC is not set.*/CONFIG_SW_SYNC=y/g' \
	-e 's/# CONFIG_SW_SYNC_USER is not set.*/CONFIG_SW_SYNC_USER=y/g' \
	defconfig
}

sync_off() {
    sed --follow-symlinks -i \
	-e 's/^CONFIG_SYNC=y.*/# CONFIG_SYNC is not set/g' \
	-e 's/^CONFIG_SW_SYNC=y.*/# CONFIG_SW_SYNC is not set/g' \
	-e 's/^CONFIG_SW_SYNC_USER=y.*/# CONFIG_SW_SYNC_USER is not set/g' \
	defconfig
}

vsync_off() {
    sed --follow-symlinks -i -e 's/#define USE_VSYNC_MODE USE_VSYNC_SYSFS/#define USE_VSYNC_MODE USE_VSYNC_OFF/g' \
	drivers/video/samsung/s3cfb_main.c
}

vsync_on() {
    sed --follow-symlinks -i -e 's/#define USE_VSYNC_MODE USE_VSYNC_OFF/#define USE_VSYNC_MODE USE_VSYNC_SYSFS/g' \
	drivers/video/samsung/s3cfb_main.c
}

case $1 in
    son)
	sync_on
	;;
    sync_on)
	sync_on
	;;
    soff)
	sync_off
	;;
    sync_off)
	sync_off
	;;
    von)
	vsync_on
	;;
    vsync_on)
	vsync_on
	;;
    voff)
	vsync_off
	;;
    vsync_off)
	vsync_off
	;;
    *)
	echo "vsync.sh <son, soff, von, voff> <sync_on, sync_off, vsync_on, vsync_off>"
	;;
esac

sync_verbose
