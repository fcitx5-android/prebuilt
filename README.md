# fcitx5-android-prebuilt-libs

Prebuit static libraries for [fcitx5-android-poc](https://github.com/rocka/fcitx5-android-poc).
Built with Android NDK 23.1.7779620, `ANDROID_PLATFORM` (aka `ANDROID_NATIVE_API_LEVEL`) 23.

## boost

Upstream repo: [moritz-wundke/Boost-for-Android](https://github.com/moritz-wundke/Boost-for-Android)

```bash
./build-android.sh \
--boost=1.78.0 \
--with-libraries=filesystem,iostreams,regex \
--arch=armeabi-v7a,arm64-v8a,x86,x86_64 \
--target-version=23 \
--layout="" \
$ANDROID_SDK_ROOT/ndk/23.1.7779620
```

**Note:** In order to reduce repo size, boost headers are extracted to [boost/include](./boost/include), and symlinked to separated ABI targets.

## fmt

Upstream repo: [fmtlib/fmt](https://github.com/fmtlib/fmt)

Build script: [./scripts/build-fmt.sh](./scripts/build-fmt.sh)

```bash
ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/23.1.7779620 \
ANDROID_SDK_CMAKE_VERSION=3.18.1 \
ANDROID_PLATFORM=23 \
ANDROID_ABI=armeabi-v7a,arm64-v8a,x86,x86_64 \
./build-fmt.sh
```

## libevent

Upstream repo: [libevent/libevent](https://github.com/libevent/libevent/tree/release-2.1.12-stable)

Build script: [./scripts/build-libevent.sh](./scripts/build-libevent.sh)

```bash
ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/23.1.7779620 \
ANDROID_SDK_CMAKE_VERSION=3.18.1 \
ANDROID_PLATFORM=23 \
ANDROID_ABI=armeabi-v7a,arm64-v8a,x86,x86_64 \
./build-libevent.sh
```

## libintl-lite

Upstream repo: [j-jorge/libintl-lite](https://github.com/j-jorge/libintl-lite)

```bash
ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/23.1.7779620 \
ANDROID_SDK_CMAKE_VERSION=3.18.1 \
ANDROID_PLATFORM=23 \
ANDROID_ABI=armeabi-v7a,arm64-v8a,x86,x86_64 \
./build-android-cmake.sh
```

## libime

Upstream repo: [fcitx/libime](https://github.com/fcitx/libime)

Build script: [./scripts/libime-data-gen.sh](./scripts/libime-data-gen.sh)

Build dependencies: [python3](https://archlinux.org/packages/extra/x86_64/python/), [libime](https://archlinux.org/packages/community/x86_64/libime/)

```bash
./libime-data-gen.sh
```

## lua

Upstream repo (forked): [rocka/LuaCMake](https://github.com/rocka/LuaCMake)

Build script: [./scripts/build-lua.sh](./scripts/build-lua.sh)

```bash
ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/23.1.7779620 \
ANDROID_SDK_CMAKE_VERSION=3.18.1 \
ANDROID_PLATFORM=23 \
ANDROID_ABI=armeabi-v7a,arm64-v8a,x86,x86_64 \
./build-lua.sh
```

## spell-dict

Upstream repo: [fcitx/fcitx5](https://github.com/fcitx/fcitx5/blob/master/src/modules/spell/dict)

Build script: [./scripts/spell-dict-gen.sh](./scripts/spell-dict-gen.sh)

Build dependencies: [fcitx5](https://archlinux.org/packages/community/x86_64/fcitx5/)

```bash
./spell-dict-gen.sh
```
