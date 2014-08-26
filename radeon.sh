#!/bin/sh

#sudo apt-get -yu remove xserver-xorg-video-radeonhd
#sudo apt-get -yu remove xserver-xorg-video-radeon
#sudo apt-get -yu remove xserver-xorg-video-ati
#sudo apt-get -yu remove xserver-xorg-video-all

#sudo apt-get -yu install xserver-xorg-video-radeonhd
#sudo apt-get -yu install xserver-xorg-video-radeon
#sudo apt-get -yu install xserver-xorg-video-ati
#sudo apt-get -yu install xserver-xorg-video-all

#sudo service gdm stop
sudo apt-get -yu remove xserver-xorg-video-*
sudo apt-get -yu install xserver-xorg-video-radeon
