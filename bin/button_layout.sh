#!/bin/sh

#BUTTON_LAYOUT="close,minimize,maximize:menu"
BUTTON_LAYOUT="close,minimize,maximize:"
#BUTTON_LAYOUT="menu:close,minimize,maximize"
METACITY="/apps/metacity/general/button_layout"
GNOME_SHELL="/desktop/gnome/shell/windows/button_layout"

gconftool-2 --set $METACITY --type string "$BUTTON_LAYOUT"
gconftool-2 --set $GNOME_SHELL --type string "$BUTTON_LAYOUT"
gconftool-2 --get $METACITY
gconftool-2 --get $GNOME_SHELL 

