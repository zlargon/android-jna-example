#!/bin/bash
set -e
root=$(pwd)

# Android API Level
API="21"

# echo yellow
function echo_y () {
    local YELLOW="\033[1;33m"
    local RESET="\033[0m"
    echo -e "${YELLOW}$@${RESET}"
}

# clean
rm -rf build dist
mkdir  build dist

# 1. check SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "[android] environment variable 'ANDROID_HOME' need to be setup"
    exit 1
fi

# 2. check NDK
if [ -z "$ANDROID_NDK_ROOT" ]; then
    echo "[android] environment variable 'ANDROID_NDK_ROOT' need to be setup"
    exit 1
fi

# 3. check toolchain platform
cd ${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt
PLATFORM=$(ls -1 | head -1)     # e.g. darwin-x86_64
if [ -z "$PLATFORM" ]; then
    echo "[android] get toolchain platform failed"
    exit 1
fi

# 4. use cmake and ninja from Android SDK
cd ${ANDROID_HOME}/cmake/3.10.*/bin/
CMAKE=$(pwd)/cmake
NINJA=$(pwd)/ninja

# 5. build libraries
cd $root/build
ARCHS="armeabi-v7a arm64-v8a x86 x86_64"
for ABI in $ARCHS
do
    echo_y "build ${ABI}"

    # cmake generate ninja project
    ${CMAKE} -H".." -B"${ABI}" -G"Ninja"        \
        -DBUILD_SHARED_LIBS="ON"                \
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

    # move to dist
    mkdir -p ${root}/dist/${ABI}
    mv ${ABI}/out/*.so ${root}/dist/${ABI}

    # install output shared library to jniLibs
    cp ${root}/dist/${ABI}/libhello.so ${root}/../hellosdk/src/main/jniLibs/${ABI}
done

# remove build folder
rm -rf ${root}/build
