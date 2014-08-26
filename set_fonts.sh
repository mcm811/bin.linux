#!/bin/sh

gconftool-2 --owner root --set /desktop/gnome/interface/font_name --type string "Sans 9"
gconftool-2 --owner root --set /desktop/gnome/interface/document_font_name --type string "Sans 9"
gconftool-2 --owner root --set /apps/nautilus/preferences/desktop_font --type string "Sans 9"
gconftool-2 --owner root --set /apps/metacity/general/titlebar_font --type string "Sans Bold 9"
gconftool-2 --owner root --set /desktop/gnome/interface/monospace_font_name --type string "Monospace 9" 

