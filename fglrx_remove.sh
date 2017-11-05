#!/bin/sh

#sudo apt-get -y remove fglrx fglrx-amdcccle fglrx-modaliases fglrx-dev
sudo apt-get -y remove fglrx fglrx-amdcccle fglrx-dev
sudo rm /etc/X11/xorg.conf
#gconftool-2 --unset /apps/compiz/plugins/workarounds/allscreens/options/fglrx_xgl_fix

