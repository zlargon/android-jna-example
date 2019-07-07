#!/bin/bash
set -e
root=$(pwd)

# Android API Level
API="21"

# color code
RED="\033[0;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# echo yellow
function echo_y () {
    echo -e "${YELLOW}$@${RESET}"
}

# echo red
function echo_r () {
    echo -e "${RED}$@${RESET}"
}

# clean
rm -rf   build dist
mkdir -p build dist

# 1. check SDK
if [ -z "$ANDROID_HOME" ]; then
    echo_r "[android] environment variable 'ANDROID_HOME' need to be setup"
    exit 1
fi

# 2. check NDK
if [ -z "$ANDROID_NDK_ROOT" ]; then
    echo_r "[android] environment variable 'ANDROID_NDK_ROOT' need to be setup"
    exit 1
fi

# 3. check toolchain platform
cd ${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt
PLATFORM=$(ls -1 | head -1)     # e.g. darwin-x86_64
if [ -z "$PLATFORM" ]; then
    echo_r "[android] get toolchain platform failed"
    exit 1
fi

# 4. TOOLCHAIN
TOOLCHAIN="${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/${PLATFORM}/bin"

# 5. use cmake and ninja from Android SDK
cd ${ANDROID_HOME}/cmake/3.10.*/bin/
CMAKE=$(pwd)/cmake
NINJA=$(pwd)/ninja

# build function
function build () {
    cd ${root}/build

    # cmake generate ninja project
    echo_y "[android] build ${ABI} libhello.a"
    ${CMAKE} -H".." -B"${ABI}" -G"Ninja"        \
        -DANDROID_ABI="${ABI}"                  \
        -DANDROID_NDK=${ANDROID_NDK_ROOT}       \
        -DCMAKE_LIBRARY_OUTPUT_DIRECTORY="out"  \
        -DCMAKE_BUILD_TYPE="Release"            \
        -DCMAKE_MAKE_PROGRAM=${NINJA}           \
        -DANDROID_NATIVE_API_LEVEL=${API}       \
        -DANDROID_TOOLCHAIN="clang"             \
        -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake"

    # cmake build
    ${CMAKE} --build "${ABI}"

    # generate shared library
    echo_y "[android] build ${ABI} libhello.so"
    dist=${root}/dist/${ABI}
    mkdir -p ${dist}
    cd ${dist}
    ${AR} x ${root}/build/${ABI}/libhello.a
    # ${CC} -std=c++11 -shared -o libhello.so *.o -llog
    ${CC} -shared -o libhello.so *.o -llog

    # remove object files
    rm -rf *.o

    # install output shared library to jniLibs
    dist=${root}/../hellosdk/src/main/jniLibs/${ABI}
    mkdir -p ${dist}
    cp ${root}/dist/${ABI}/libhello.so ${dist}
}

# 6-1. armeabi-v7a (20.0 MB)
ABI="armeabi-v7a"
AR="${TOOLCHAIN}/arm-linux-androideabi-ar"
CC="${TOOLCHAIN}/armv7a-linux-androideabi${API}-clang"
build

# 6-2.arm64-v8a (Release: 20.5 MB)
ABI="arm64-v8a"
AR="${TOOLCHAIN}/aarch64-linux-android-ar"
CC="${TOOLCHAIN}/aarch64-linux-android${API}-clang"
build

# 6-3. x86 (Release: 24.4 MB)
ABI="x86"
AR="${TOOLCHAIN}/i686-linux-android-ar"
CC="${TOOLCHAIN}/i686-linux-android${API}-clang"
build

# 6-4. x86_64 (Release: 27.7 MB)
ABI="x86_64"
AR="${TOOLCHAIN}/x86_64-linux-android-ar"
CC="${TOOLCHAIN}/x86_64-linux-android${API}-clang"
build

# 7. remove build folder
rm -rf ${root}/build
