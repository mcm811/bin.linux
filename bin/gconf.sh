#!/bin/sh

#gconftool-2 --set /apps/mutter/general/overlay_key --type string "Super_L"
#gconftool-2 --set /desktop/gnome/shell/windows/button_layout --type string "menu:minimize,maximize,close"
gconftool-2 --set /desktop/gnome/shell/windows/button_layout --type string "close,minimize,maximize:"
gnome-shell --replace &
