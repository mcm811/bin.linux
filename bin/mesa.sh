sudo apt-get install \
autogen \
autoconf \
libtool \
gettext \
libpciaccess-dev \
makedepend \
xutils-dev \
x11proto-gl-dev \
libdrm-dev \
x11proto-dri2-dev \
libxext-dev \
libxdamage-dev \
libx11-xcb-dev \
libxcb-glx0-dev \
libexpat-dev \
libgbm-dev \
libxvmc-dev \
libvdpau-dev \
libxcb-dri2-0-dev \
libxcb-xfixes0-dev \
clang \
llvm-dev \
python-libxml2

sudo apt-get install
##################################################

git clone git://anongit.freedesktop.org/mesa/drm
cd drm
git remote add drm http://anongit.freedesktop.org/git/mesa/drm.git
git fetch drm
git merge drm/master

./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
make -j2
sudo make install

git clone git://anongit.freedesktop.org/mesa/mesa
cd mesa
git remote add mesa http://anongit.freedesktop.org/git/mesa/mesa.git
git fetch mesa
git merge mesta/master

./autogen.sh \
--prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu \
--with-dri-driverdir=/usr/lib/xorg/modules/dri \
--with-dri-drivers= \
--with-gallium-drivers=r600 \
--with-egl-platforms=x11,drm \
--enable-gallium-llvm \
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
--enable-glx-tls \
--enable-texture-float \
--enable-shared-glapi \
--enable-d3d1x

#--enable-r600-llvm-compiler \
#--enable-opencl \
--with-clang-libdir

make -j2

MESA_ROOT=/opt/mesa
mkdir $MESA_ROOT
cd $MESA_ROOT
cat <<EOF > env.sh
export MESA_ROOT=$MESA_ROOT
export LD_LIBRARY_PATH=\$MESA_ROOT/prefix/lib:\$LD_LIBRARY_PATH
PATH=\$MESA_ROOT/prefix/bin:\$PATH
export PKG_CONFIG_PATH=\$MESA_ROOT/prefix/lib/pkgconfig:\$PKG_CONFIG_PATH
EOF
source env.sh

sudo sh -c "echo LD_LIBRARY_PATH=$MESA_ROOT/prefix/lib:\$LD_LIBRARY_PATH >> /etc/environment"
sudo sh -c "echo DRI_DRIVER_PATH=$MESA_ROOT/prefix/lib/dri >> /etc/environment"




  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
  --libdir=DIR            object code libraries [EPREFIX/lib]
  --includedir=DIR        C header files [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
  --mandir=DIR            man documentation [DATAROOTDIR/man]
  --docdir=DIR            documentation root [DATAROOTDIR/doc/libdrm]
