#!/bin/sh

CMD="$1"
EXTRACMD="$2"
A_TOP=${PWD}
CUR_DIR=`dirname $0`

fglrx_install() {
	sudo apt-get install debhelper
	sh ./amd-driver-installer-*-x86.x86_64.run --listpkg
	sh ./amd-driver-installer-*-x86.x86_64.run --buildpkg Ubuntu/precise
	sudo dpkg -i *.deb
	sudo aticonfig -f --initial
	sudo apt-get install xvba-va-driver
}

dkms_install() {
	sudo ln -s /usr/src/linux-headers-3.5.0-030500-generic /lib/modules/3.5.0-030500-generic/build
	sudo dkms status
	sudo dkms remove -m fglrx --all
	sudo dkms sudo dkms build -m fglrx -v 9.000
	sudo dkms sudo dkms install -m fglrx -v 9.000
}


fglrx_uninstall() {
    sudo dpkg -r fglrx fglrx-amdcccle fglrx-dev xvba-va-driver
	sudo rm /etc/X11/xorg.conf
}

case "$CMD" in
    install)
        fglrx_install
        exit
        ;;
    dkms)
	dkms_install
	exit
	;;
    uninstall)
	fglrx_uninstall
	exit
	;;
    *)
        fglrx_install
	;;
esac
