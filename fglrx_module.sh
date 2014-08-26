#!/bin/sh

# install module
sudo dkms status
sudo dkms build -m fglrx -v 8.771
sudo dkms install -m fglrx -v 8.771

