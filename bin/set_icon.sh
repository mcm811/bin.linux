#!/bin/sh

gconftool-2 --set /desktop/gnome/interface/toolbar_style --type string "icons"
gconftool-2 --set /desktop/gnome/interface/buttons_have_icons --type boolean false
gconftool-2 --set /desktop/gnome/interface/menus_have_icons --type boolean true

