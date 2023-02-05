#!/usr/bin/env bash

CMAKE=""

build_libevent() {
    echo ">>> Building libevent for $1"
    # make cmake generate relative _IMPORT_PREFIX
    sed -i '1456s|${CMAKE_INSTALL_PREFIX}/||' CMakeLists.txt
    sed -i '1475{\|"${PROJECT_SOURCE_DIR}/include"|d}' CMakeLists.txt
    sed -i '1475s|${PROJECT_BINARY_DIR}/||' CMakeLists.txt
    "$CMAKE" -B build \
        -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT"/build/cmake/android.toolchain.cmake \
        -DANDROID_ABI="$1" \
        -DANDROID_PLATFORM="$ANDROID_PLATFORM" \
        -DANDROID_STL=c++_shared \
        -DCMAKE_INSTALL_PREFIX=out/libevent/"$1" \
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
    "$CMAKE" --build build
    # avoid installing pkgconf files and python scripts
    "$CMAKE" --install build --component lib
    "$CMAKE" --install build --component dev
    rm -rf ./build
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

CMAKE="$ANDROID_SDK_ROOT/cmake/$ANDROID_SDK_CMAKE_VERSION/bin/cmake"

if [ ! -f "$CMAKE" ]; then
    echo "Cannot find cmake: '$CMAKE'"
    exit 1
fi

IFS=',' read -ra ARCH <<< "${ANDROID_ABI}"

for a in "${ARCH[@]}"; do
  build_libevent "$a"
done
