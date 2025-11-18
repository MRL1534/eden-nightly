#!/bin/sh
set -ex

case "$TARGET" in
  FreeBSD)
    sed -i '' -e 's/quarterly/latest/' /etc/pkg/FreeBSD.conf
    export ASSUME_ALWAYS_YES=true
    pkg install -y autoconf bash boost-libs catch2 ccache cmake ffmpeg gcc gmake git glslang libfmt libzip nasm llvm20 \
                ninja openssl opus pkgconf pcre2 qt6-base qt6ct qt6-tools qt6-translations qt6-wayland sdl2 unzip vulkan-tools vulkan-loader wget zip zstd
    ;;
  Solaris)
    pkg install git cmake developer/gcc-14 developer/build/ninja developer/build/gnu-make developer/build/autoconf \
                qt6 libzip libusb-1 zlib compress/zstd unzip pkg-config nasm mesa library/libdrm

    # build glslang from source
    git clone --depth 1 https://github.com/KhronosGroup/glslang.git
    cd glslang
    cmake -B build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DENABLE_OPT=OFF \
      -G Ninja
    cd build
    ninja
    sudo ninja install
    ;;
esac
