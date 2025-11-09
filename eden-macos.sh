#!/bin/bash -e

echo "Making Eden for MacOS"
export LIBVULKAN_PATH="/opt/homebrew/lib/libvulkan.1.dylib"

cd ./eden

# hook the updater to check my repo
echo "-- Applying updater patch..."
git apply ../patches/update.patch
echo "   Done."

COUNT="$(git rev-list --count HEAD)"
APP_NAME="Eden-${COUNT}-MacOS-${TARGET}"
echo "-- Build Configuration:"
echo "   Target: ${TARGET}"
echo "   Count: ${COUNT}"
echo "   App Name: ${APP_NAME}"

echo "-- Starting build..."
mkdir -p build
cd build
cmake .. -GNinja \
    -DYUZU_TESTS=OFF \
	-DBUILD_TESTING=OFF \
 	-DDYNARMIC_TESTS=OFF \
    -DYUZU_USE_BUNDLED_QT=OFF \
	-DYUZU_USE_EXTERNAL_SDL2=ON \
	-DYUZU_USE_EXTERNAL_FFMPEG=ON \
	-DYUZU_USE_BUNDLED_SIRIT=ON \
	-DYUZU_USE_CPM=ON \
	-DYUZU_USE_FASTER_LD=OFF \
    -DENABLE_QT_TRANSLATION=ON \
	-DENABLE_UPDATE_CHECKER=ON \
    -DYUZU_ENABLE_LTO=ON \
    -DUSE_DISCORD_PRESENCE=OFF \
    -DYUZU_CMD=OFF \
    -DYUZU_ROOM_STANDALONE=OFF \
    -DCMAKE_OSX_ARCHITECTURES="$TARGET" \
    -DCMAKE_CXX_FLAGS="-w" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
ninja
echo "-- Build Completed."

echo "-- Build stats:"
ccache -s -v

# Bundle and code-sign eden.app
echo "-- Bundling and code-signing Eden.app..."
APP=./bin/eden.app
macdeployqt "$APP"
codesign --deep --force --verify --verbose --sign - "$APP"

# Pack for upload
echo "-- Packing build artifacts..."
mkdir -p artifacts
mkdir "$APP_NAME"
cp -a ./bin/. "$APP_NAME"
ZIP_NAME="$APP_NAME.7z"
7z a -t7z -mx=9 "$ZIP_NAME" "$APP_NAME"
mv -v "$ZIP_NAME" artifacts/

echo "=== ALL DONE! ==="
