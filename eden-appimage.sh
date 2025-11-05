#!/bin/bash

set -e

export APPIMAGE_EXTRACT_AND_RUN=1
export ARCH="$(uname -m)"

SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
PELF="https://github.com/xplshn/pelf/releases/latest/download/pelf_$ARCH"

case "$1" in
    steamdeck)
        echo "Making Eden Optimized Build for Steam Deck"
        CMAKE_CXX_FLAGS="-march=znver2 -mtune=znver2 -Ofast -pipe -flto=auto -fuse-ld=mold -w"
        CMAKE_C_FLAGS="-march=znver2 -mtune=znver2 -Ofast -pipe -flto=auto -fuse-ld=mold -w"
 		PROFILE="steamdeck"
   		EXTERNAL_SDL2="ON"
        TARGET="Steamdeck"
		CCACHE="ccache"
		CC="gcc"
		CXX="g++"
        ;;
    steamdeck-pgo)
        echo "Making Eden PGO_Optimized Build for Steam Deck"
        # merge PGO data
        cd pgo
        chmod +x ./merge.sh
        ./merge.sh 5 3 1
        cd ..

        CMAKE_CXX_FLAGS="-march=znver2 -mtune=znver2 -Ofast -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
        CMAKE_C_FLAGS="-march=znver2 -mtune=znver2 -Ofast -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
 		PROFILE="steamdeck"
   		EXTERNAL_SDL2="ON"
        TARGET="Steamdeck-PGO"
  		CC="clang"
		CXX="clang++"
        ;;
    rog)
        echo "Making Eden Optimized Build for ROG ALLY X"
        CMAKE_CXX_FLAGS="-march=znver4 -mtune=znver4 -Ofast -pipe -flto=auto -fuse-ld=mold -w"
        CMAKE_C_FLAGS="-march=znver4 -mtune=znver4 -Ofast -pipe -flto=auto -fuse-ld=mold -w"
 		PROFILE="steamdeck"
   		EXTERNAL_SDL2="ON"
        TARGET="ROG_ALLY"
		CCACHE="ccache"
		CC="gcc"
		CXX="g++"
        ;;
    rog-pgo)
        echo "Making Eden PGO Optimized Build for ROG ALLY X"
        # merge PGO data
        cd pgo
        chmod +x ./merge.sh
        ./merge.sh 5 3 1
        cd ..

        CMAKE_CXX_FLAGS="-march=znver4 -mtune=znver4 -Ofast -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
        CMAKE_C_FLAGS="-march=znver4 -mtune=znver4 -Ofast -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
 		PROFILE="steamdeck"
   		EXTERNAL_SDL2="ON"
        TARGET="ROG_ALLY-PGO"
  		CC="clang"
		CXX="clang++"
        ;;
    common)
        echo "Making Eden Optimized Build for Modern CPUs"
        CMAKE_CXX_FLAGS="-march=x86-64-v3 -Ofast -pipe -flto=auto -fuse-ld=mold -w"
        CMAKE_C_FLAGS="-march=x86-64-v3 -Ofast -pipe -flto=auto -fuse-ld=mold -w"
        TARGET="Common"
		CCACHE="ccache"
		CC="gcc"
		CXX="g++"
		BUNDLED_SDL2="ON"
  		EXTERNAL_SDL2="OFF"
        ;;
    common-pgo)
        echo "Making Eden PGO Optimized Build for Modern CPUs"
        # merge PGO data
        cd pgo
        chmod +x ./merge.sh
        ./merge.sh 5 3 1
        cd ..

        CMAKE_CXX_FLAGS="-march=x86-64-v3 -Ofast -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
        CMAKE_C_FLAGS="-march=x86-64-v3 -Ofast -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
        TARGET="Common-PGO"
  		CC="clang"
		CXX="clang++"
		BUNDLED_SDL2="ON"
  		EXTERNAL_SDL2="OFF"
        ;;
    legacy)
        echo "Making Eden Optimized Build for Legacy CPUs"
        CMAKE_CXX_FLAGS="-march=x86-64 -mtune=generic -O2 -pipe -flto=auto -fuse-ld=mold -w"
        CMAKE_C_FLAGS="-march=x86-64 -mtune=generic -O2 -pipe -flto=auto -fuse-ld=mold -w"
        TARGET="Legacy"
		CCACHE="ccache"
		CC="gcc"
		CXX="g++"
		BUNDLED_SDL2="ON"
  		EXTERNAL_SDL2="OFF"
        ;;
    legacy-pgo)
        echo "Making Eden Optimized Build for Legacy CPUs"
        # merge PGO data
        cd pgo
        chmod +x ./merge.sh
        ./merge.sh 5 3 1
        cd ..

        CMAKE_CXX_FLAGS="-march=x86-64 -mtune=generic -O2 -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
        CMAKE_C_FLAGS="-march=x86-64 -mtune=generic -O2 -pipe -flto=thin -fuse-ld=lld -fprofile-use=${GITHUB_WORKSPACE}/pgo/eden.profdata -fprofile-correction -w"
        TARGET="Legacy-PGO"
  		CC="clang"
		CXX="clang++"
		BUNDLED_SDL2="ON"
  		EXTERNAL_SDL2="OFF"
        ;;
    aarch64)
        echo "Making Eden Optimized Build for AArch64"
        CMAKE_CXX_FLAGS="-march=armv8-a -mtune=generic -Ofast -pipe -flto=auto -fuse-ld=mold -w"
        CMAKE_C_FLAGS="-march=armv8-a -mtune=generic -Ofast -pipe -flto=auto -fuse-ld=mold -w"
        TARGET="Linux"
		CCACHE="ccache"
		CC="gcc"
		CXX="g++"
		BUNDLED_SDL2="ON"
  		EXTERNAL_SDL2="OFF"
        ;;
esac

cd ./eden
COUNT="$(git rev-list --count HEAD)"
DATE="$(date +"%d_%m_%Y")"

# hook the updater to check my repo
git apply ../patches/update.patch

mkdir build
cd build
cmake .. -GNinja \
    -DYUZU_USE_BUNDLED_QT=OFF \
	-DYUZU_USE_BUNDLED_FFMPEG=ON \
	-DYUZU_USE_BUNDLED_SIRIT=ON \
	-DYUZU_USE_CPM=ON \
	-DBUILD_TESTING=OFF \
    -DYUZU_TESTS=OFF \
	-DDYNARMIC_TESTS=OFF \
    -DYUZU_ENABLE_LTO=ON \
	-DDYNARMIC_ENABLE_LTO=ON \
    -DENABLE_QT_TRANSLATION=ON \
	-DENABLE_UPDATE_CHECKER=ON \
    -DUSE_DISCORD_PRESENCE=ON \
    -DYUZU_CMD=OFF \
	-DYUZU_ROOM=ON \
    -DYUZU_ROOM_STANDALONE=OFF \
    -DCMAKE_SYSTEM_PROCESSOR="$(uname -m)" \
    -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER_LAUNCHER="${CCACHE:-}" \
	-DCMAKE_CXX_COMPILER_LAUNCHER="${CCACHE:-}" \
	-DCMAKE_C_COMPILER="${CC:-}" \
 	-DCMAKE_CXX_COMPILER="${CXX:-}" \
    -DCMAKE_EXE_LINKER_FLAGS="-Wl,--as-needed" \
    ${PROFILE:+-DYUZU_SYSTEM_PROFILE="$PROFILE"} \
	${BUNDLED_SDL2:+-DYUZU_USE_BUNDLED_SDL2="$BUNDLED_SDL2"} \
 	${EXTERNAL_SDL2:+-DYUZU_USE_EXTERNAL_SDL2="$EXTERNAL_SDL2"} \
    ${CMAKE_CXX_FLAGS:+-DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS"} \
    ${CMAKE_C_FLAGS:+-DCMAKE_C_FLAGS="$CMAKE_C_FLAGS"}
ninja
ccache -s -v

# Use sharun to generate AppDir
cd ..
export ICON="$PWD"/dist/dev.eden_emu.eden.svg
export DESKTOP="$PWD"/dist/dev.eden_emu.eden.desktop
export OPTIMIZE_LAUNCH=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_QT=1
export OUTNAME="Eden-${COUNT}-${TARGET}-${ARCH}.AppImage"

wget -q --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun ./build/bin/eden
echo 'QT_QPA_PLATFORM=xcb' >> AppDir/.env

# Use uruntie to make appimage
wget -q --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage

mkdir -p appimage
mv -v "${OUTNAME}" appimage/

# Use pelf to make appbundle
wget -q --retry-connrefused --tries=30 "$PELF" -O ./pelf
chmod +x ./pelf

APPBUNDLE="Eden-${COUNT}-${TARGET}-${ARCH}.dwfs.AppBundle"
ln -sfv ./AppDir/eden.svg ./AppDir/.DirIcon.svg
cp -v ../io.github.eden_emu.Eden.appdata.xml ./AppDir
./pelf --add-appdir ./AppDir --appbundle-id="Eden-${DATE}-Escary" --compression "-C zstd:level=22 -S26 -B6" --output-to "$APPBUNDLE"

mkdir -p appbundle
mv -v "${APPBUNDLE}"* appbundle/
