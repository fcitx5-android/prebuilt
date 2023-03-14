#!/usr/bin/env bash

CMAKE=""
NINJA=""

build_opencc() {
    local BUILD_ABI="$1"
    local BUILD_DIR="./build_$BUILD_ABI"
    local INSTALL_DIR="./out/opencc/$BUILD_ABI"
    if [ -e "$BUILD_DIR" ]; then
        echo ">>> Cleaning previous build intermediates"
        rm -r "$BUILD_DIR"
    fi
    echo ">>> Building opencc for $BUILD_ABI"
    # remove absolute path by __FILE__ macro
    sed -i "18{/^set_target_properties/i target_compile_options(marisa PRIVATE \"-ffile-prefix-map=\$\\{CMAKE_CURRENT_SOURCE_DIR\\}=.\")
}" deps/marisa-0.2.6/CMakeLists.txt
    "$CMAKE" -B "$BUILD_DIR" -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
        -DCMAKE_MAKE_PROGRAM="$NINJA" \
        -DANDROID_ABI="$BUILD_ABI" \
        -DANDROID_PLATFORM="$ANDROID_PLATFORM" \
        -DANDROID_STL=c++_shared \
        -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
        -DCMAKE_CXX_FLAGS="-std=c++17" \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_DOCUMENTATION=OFF \
        -DBUILD_PYTHON=OFF \
        -DENABLE_GTEST=OFF \
        -DENABLE_BENCHMARK=OFF \
        -DENABLE_DARTS=OFF \
        -DUSE_SYSTEM_MARISA=OFF \
        -DUSE_SYSTEM_PYBIND11=OFF \
        -DUSE_SYSTEM_RAPIDJSON=OFF \
        -DUSE_SYSTEM_TCLAP=OFF \
        -DSHARE_INSTALL_PREFIX=share \
        -DINCLUDE_INSTALL_DIR=include \
        -DSYSCONF_INSTALL_DIR=etc \
        -DLIB_INSTALL_DIR=lib \
        .
    "$CMAKE" --build "$BUILD_DIR"
    "$CMAKE" --install "$BUILD_DIR"
    rm -r "$INSTALL_DIR/"{bin,lib/pkgconfig}
}

if [ -z "${ANDROID_SDK_ROOT}" ]; then
    echo "ANDROID_SDK_ROOT should be set to Android SDK path."
    exit 1
fi

if [ -z "${ANDROID_NDK_ROOT}" ]; then
    echo "ANDROID_NDK_ROOT should be set to Android NDK path."
    exit 1
fi

if [ -z "${ANDROID_SDK_CMAKE_VERSION}" ]; then
    echo "ANDROID_SDK_CMAKE_VERSION should be set to desired cmake version in \$ANDROID_SDK_ROOT/cmake. eg. 3.18.1"
    exit 1
fi

if [ -z "${ANDROID_PLATFORM}" ]; then
    echo "ANDROID_PLATFORM should be set to minimum API level supported by the library. eg. 21"
    exit 1
fi

if [ -z "${ANDROID_ABI}" ]; then
    echo "ANDROID_ABI not set; can be a ',' separated list. eg. armeabi-v7a,arm64-v8a"
    exit 1
fi

ANDROID_SDK_CMAKE_BIN="$ANDROID_SDK_ROOT/cmake/$ANDROID_SDK_CMAKE_VERSION/bin"
CMAKE="$ANDROID_SDK_CMAKE_BIN/cmake"
NINJA="$ANDROID_SDK_CMAKE_BIN/ninja"

if [ ! -f "$CMAKE" ]; then
    echo "Cannot find cmake: '$CMAKE'"
    exit 1
fi

IFS=',' read -ra ARCH <<< "${ANDROID_ABI}"

for a in "${ARCH[@]}"; do
  build_opencc "$a"
done
