#!/bin/bash

git pull

./autogen.sh \
--prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu \
--with-dri-driverdir=/usr/lib/xorg/modules/dri \
--with-dri-drivers= \
--with-gallium-drivers=r300,r600,svga,swrast \
--with-egl-platforms=x11,drm \
--enable-gallium-egl \
--disable-gallium-gbm \
--enable-gallium-g3dvl \
--enable-egl \
--enable-gbm \
--enable-xvmc \
--enable-vdpau \
--disable-debug \
--enable-gles1 \
--enable-gles2 \
--enable-openvg \
--enable-xa \
--enable-texture-float \
--enable-shared-glapi

make -j8

sudo make install
