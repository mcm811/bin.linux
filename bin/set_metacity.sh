#!/bin/sh

gconftool-2 --set /apps/metacity/general/compositing_manager --type boolean true
gconftool-2 --set /desktop/gnome/session/required_components/windowmanager --type string "metacity"
gconftool-2 --get /desktop/gnome/session/required_components/windowmanager
gconftool-2 --get /apps/metacity/general/compositing_manager

