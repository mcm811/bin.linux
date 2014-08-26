#!/bin/bash

config_on=$1
if [ "$1" = "on" ]; then
    echo "nfc_dmb: on"
elif [ "$1" = "off" ]; then
    echo "nfc_dmb: off"
else
    echo "dmbconfig.sh <on|off>"
    return
fi

dmb_on() {
    sed --follow-symlinks -i \
	-e "/.*CONFIG_TDMB.*/d" \
	-e '/.*CONFIG_RADIO_ADAPTERS.*/a \
CONFIG_TDMB=y\
CONFIG_TDMB_SPI=y\
# CONFIG_TDMB_EBI is not set\
# CONFIG_TDMB_TSIF is not set\
# CONFIG_TDMB_VENDOR_FCI is not set\
CONFIG_TDMB_VENDOR_INC=y\
# CONFIG_TDMB_T39F0 is not set\
CONFIG_TDMB_T3900=y\
# CONFIG_TDMB_T3700 is not set\
# CONFIG_TDMB_T3300 is not set\
# CONFIG_TDMB_VENDOR_RAONTECH is not set\
CONFIG_TDMB_VENDOR_TELECHIPS=y\
CONFIG_TDMB_TCC3170=y\
# CONFIG_TDMB_SIMUL is not set\
# CONFIG_TDMB_ANT_DET is not set' \
    $@
    grep TDMB $@
}

dmb_off() {
    sed --follow-symlinks -i \
	-e "/.*CONFIG_TDMB.*/d" \
	-e '/.*CONFIG_RADIO_ADAPTERS.*/a \
# CONFIG_TDMB is not set\
# CONFIG_TDMB_SPI is not set\
# CONFIG_TDMB_EBI is not set\
# CONFIG_TDMB_TSIF is not set\
# CONFIG_TDMB_VENDOR_FCI is not set\
# CONFIG_TDMB_VENDOR_INC is not set\
# CONFIG_TDMB_T39F0 is not set\
# CONFIG_TDMB_T3900 is not set\
# CONFIG_TDMB_T3700 is not set\
# CONFIG_TDMB_T3300 is not set\
# CONFIG_TDMB_VENDOR_RAONTECH is not set\
# CONFIG_TDMB_VENDOR_TELECHIPS is not set\
# CONFIG_TDMB_TCC3170 is not set\
# CONFIG_TDMB_SIMUL is not set\
# CONFIG_TDMB_ANT_DET is not set' \
    $@
    grep TDMB $@
}

nfc_on() {
    sed --follow-symlinks -i \
	-e "/.*CONFIG_PN544.*/d" \
	-e '/.*CONFIG_USBHUB_USB3503 is not set.*/a \
CONFIG_PN544=y' \
	$@
    grep PN544 $@
}

nfc_off() {
    sed --follow-symlinks -i \
	-e "/.*CONFIG_PN544.*/d" \
	-e '/.*CONFIG_USBHUB_USB3503 is not set.*/a \
# CONFIG_PN544 is not set' \
    $@
    grep PN544 $@
}

config() {
    if [ "$config_on" = "on" ]; then
	nfc_on $@
    else
	nfc_off $@
    fi
    dmb_off $@
    echo $PWD/$@
}

for dir in \
    /home/changmin/kernel/siyah-v4/siyahkernel3 \
    /home/changmin/kernel/siyah-v5/siyahkernel3 \
    /home/changmin/android/system_mr1/kernel/samsung/smdk4210 \
    /home/changmin/android/system_mr0/kernel/samsung/smdk4210; do
    cd $dir
    for file in .config defconfig; do
	if [ -f "$file" ]; then
	    config $file
	fi
    done
done
