#!/bin/bash

cd ~/kernel/ubuntu-raring-ee18430/debian.master/config/
cat amd64/config.common.amd64 config.common.ubuntu > ~/kernel/linux/.config
cd -

cat row_config.patch | patch -p1 -f
