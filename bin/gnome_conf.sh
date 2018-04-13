#!/bin/sh

# fonts
gconftool-2 --set /desktop/gnome/interface/font_name --type string "Sans 9"
gconftool-2 --set /desktop/gnome/interface/document_font_name --type string "Sans 10"
gconftool-2 --set /apps/nautilus/preferences/desktop_font --type string "Sans 10"
gconftool-2 --set /apps/metacity/general/titlebar_font --type string "Sans Bold 10"
gconftool-2 --set /desktop/gnome/interface/monospace_font_name --type string "Monospace 9"

# Give user a choice
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u

# gconftool-2 --set /apps/mutter/general/overlay_key --type string "Super_L"
# gconftool-2 --set /desktop/gnome/shell/windows/button_layout --type string "menu:minimize,maximize,close"
# gnome-shell --replace &
