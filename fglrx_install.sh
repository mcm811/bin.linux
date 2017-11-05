#!/bin/sh

sudo apt-get -yu install fglrx fglrx-amdcccle fglrx-modaliases fglrx-dev
sudo aticonfig -f --initial

#sudo aticonfig -f --initial --tls=off
