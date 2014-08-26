#!/bin/sh

gconftool-2 --set /desktop/gnome/session/required_components/windowmanager --type string "compiz"
gconftool-2 --get /desktop/gnome/session/required_components/windowmanager
