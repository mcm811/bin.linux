#!/bin/bash

A="$1"


case "$A" in
    kernel)
	echo "KERNEL"
	;;
    kernelclean)
	echo "KERNELCLEAN"
	;;
    *)
	echo "* OKOOOK"
	;;
esac
