#!/usr/bin/env bash

CMAKE=""
NINJA=""

build_libevent() {
    local BUILD_ABI="$1"
    local BUILD_DIR="./build_$BUILD_ABI"
    local INSTALL_DIR="./out/libevent/$BUILD_ABI"
    if [ -e "$BUILD_DIR" ]; then
        echo ">>> Cleaning previous build intermediates"
        rm -r "$BUILD_DIR"
    fi
    echo ">>> Building libevent for $BUILD_ABI"
    # make cmake generate relative _IMPORT_PREFIX
    sed -i '1456s|${CMAKE_INSTALL_PREFIX}/||' CMakeLists.txt
    sed -i '1475{\|"${PROJECT_SOURCE_DIR}/include"|d}' CMakeLists.txt
    sed -i '1475s|${PROJECT_BINARY_DIR}/||' CMakeLists.txt
    # fix LibeventConfig.cmake find_{path,library} calls in ndk toolchain
    sed -i '120s|NO_DEFAULT_PATH)|NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)|' cmake/LibeventConfig.cmake.in
    sed -i '134s|NO_DEFAULT_PATH)|NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)|' cmake/LibeventConfig.cmake.in
    "$CMAKE" -B "$BUILD_DIR" -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
        -DCMAKE_MAKE_PROGRAM="$NINJA" \
        -DANDROID_ABI="$BUILD_ABI" \
        -DANDROID_PLATFORM="$ANDROID_PLATFORM" \
        -DANDROID_STL=c++_shared \
        -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
        -DCMAKE_CXX_FLAGS="-std=c++17" \
        -DCMAKE_BUILD_TYPE=Release \
        -DEVENT__LIBRARY_TYPE=STATIC \
        -DEVENT__DISABLE_DEBUG_MODE=ON \
        -DEVENT__DISABLE_THREAD_SUPPORT=ON \
        -DEVENT__DISABLE_OPENSSL=ON \
        -DEVENT__DISABLE_BENCHMARK=ON \
        -DEVENT__DISABLE_TESTS=ON \
        -DEVENT__DISABLE_REGRESS=ON \
        -DEVENT__DISABLE_SAMPLES=ON \
        .
    "$CMAKE" --build "$BUILD_DIR"
    # avoid installing pkgconf files and python scripts
    "$CMAKE" --install "$BUILD_DIR" --component lib
    "$CMAKE" --install "$BUILD_DIR" --component dev
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
  build_libevent "$a"
done
