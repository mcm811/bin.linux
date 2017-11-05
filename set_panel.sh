#!/bin/sh

gconftool-2 --set /desktop/gnome/session/required_components/panel --type string ""
#gconftool-2 --set /desktop/gnome/session/required_components/panel --type string "avant-window-navigator"
#gconftool-2 --set /desktop/gnome/session/required_components/panel --type string "gnome-panel"
gconftool-2 --get /desktop/gnome/session/required_components/panel
