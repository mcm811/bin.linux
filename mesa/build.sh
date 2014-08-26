#!/bin/bash

git pull
sudo make clean

./autogen.sh \
--prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu \
--with-dri-driverdir=/usr/lib/xorg/modules/dri \
--with-xorg-driver-dir=/usr/lib/xorg/modules/drivers \
--with-gallium-drivers=r600,svga,swrast \
--with-egl-platforms=x11,drm \
--enable-r600-llvm-compiler \
--enable-gles-overlay --enable-gles2 --disable-gallium-egl \
--enable-gbm \
--enable-xvmc \
--enable-vdpau \
--disable-debug \
--enable-dri3=no \
--enable-xa \
--enable-texture-float \
--enable-shared-glapi \
--enable-glx-tls

make -j8 && sudo make install

pkg64() {
    sudo apt-get install libXext-dev libXdamage-dev libXfixes-dev \
        libXxf86vm-dev libX11-xcb-dev libxcb-glx0-dev \
        libxcb-xfixes0-dev libxcb-render0-dev libxcb-shape0-dev libexpat1-dev
}

#--libdir=/usr/lib/x86_64-linux-gnu
#--with-egl-driver-dir=/usr/lib/x86_64-linux-gnu/egl
#--with-vdpau-libdir=/usr/lib/x86_64-linux-gnu/vdpau
#--with-xvmc-libdir=/usr/lib/x86_64-linux-gnu
#--enable-gallium-egl
#--enable-gallium-gbm
#--enable-32-bit
#--enable-64-bit

#sudo vi /etc/ld.so.conf.d/a.conf
#/usr/lib/x86_64-linux-gnu/gbm
#/usr/lib/x86_64-linux-gnu/vdpau
#/usr/lib/x86_64-linux-gnu/gallium-pipe
#/usr/lib/x86_64-linux-gnu/egl
#/usr/lib/x86_64-linux-gnu
#/usr/lib/xorg/modules/dri
#/usr/lib/xorg/modules/drivers

build32() {
    sudo make clean
    CFLAGS="-m32" CXXFLAGS="-m32" ./autogen.sh \
        --prefix=/usr --libdir=/usr/lib/i386-linux-gnu \
        --disable-debug \
        --enable-texture-float \
        --enable-shared-glapi \
        --disable-xvmc \
        --enable-32-bit \
        --disable-64-bit
    make -j8

    sudo apt-get remove libexpat1-dev
    sudo apt-get install libexpat1-dev:i386
    sudo apt-get install libelf-dev:i386

    cd /usr/lib/i386-linux-gnu
    sudo ln -s libdrm_intel.so.1.0.0 libdrm_intel.so
    sudo ln -s libdrm_nouveau.so.2.0.0 libdrm_nouveau.so

    sudo apt-get install libXext-dev:i386 libXdamage-dev:i386 libXfixes-dev:i386 \
        libXxf86vm-dev:i386 libX11-xcb-dev:i386 libxcb-glx0-dev:i386 \
        libxcb-xfixes0-dev:i386 libxcb-render0-dev:i386 libxcb-shape0-dev:i386
}
