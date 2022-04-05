#!/usr/bin/env bash

CMAKE=""

build_libevent() {
    echo ">>> Building libevent for $1"
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
    "$CMAKE" --build build --target install
    # I don't know why cmake can't find those dirs ... so just sed it
    # https://github.com/libevent/libevent/blob/release-2.1.12-stable/cmake/LibeventConfig.cmake.in#L117
    sed -i '121s/_event_h/true/' ./out/libevent/$1/lib/cmake/libevent/LibeventConfig.cmake
    sed -i '135s/_event_lib/true/' ./out/libevent/$1/lib/cmake/libevent/LibeventConfig.cmake
    # I know it was generated, but I don't know how to tell cmake to change it's behavior ... so sed it
    # https://github.com/Kitware/CMake/blob/v3.18.1/Source/cmExportInstallFileGenerator.cxx#L191
    sed -i '45{/^set(_IMPORT_PREFIX/d}' ./out/libevent/$1/lib/cmake/libevent/LibeventTargets-static.cmake
    sed -i '45iget_filename_component(LIBEVENT_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)' ./out/libevent/$1/lib/cmake/libevent/LibeventTargets-static.cmake
    sed -i '46iget_filename_component(_IMPORT_PREFIX "${LIBEVENT_CMAKE_DIR}/../../.." ABSOLUTE)' ./out/libevent/$1/lib/cmake/libevent/LibeventTargets-static.cmake
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
