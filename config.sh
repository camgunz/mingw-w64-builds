#!/bin/bash

# export BIN_DIR="/usr/bin"
# export BUILD_TRIPLET="x86_64-pc-linux-gnu"
# export HOST_TRIPLET="i686-w64-mingw32"
# export HOST_PREFIX="/usr/$HOST_TRIPLET"

export BASE_DIR="`pwd`"
export ARCHIVE_DIR=${BASE_DIR}/archives
export SOURCE_DIR=${BASE_DIR}/source
export PATCH_DIR=${BASE_DIR}/patches
export BUILD_DIR=${BASE_DIR}/build
export PATH=$PATH:${BUILD_DIR}/bin

# export AR="${HOST_TRIPLET}-ar"
# export CC="${HOST_TRIPLET}-gcc"
# export CXX="${HOST_TRIPLET}-g++"
# export DLLTOOL="${HOST_TRIPLET}-dlltool"
# export LD="${HOST_TRIPLET}-ld"
# export NM="${HOST_TRIPLET}-nm"
# export OBJCOPY="${HOST_TRIPLET}-objcopy"
# export OBJDUMP="${HOST_TRIPLET}-objdump"
# export RANLIB="${HOST_TRIPLET}-ranlib"
# export STRIP="${HOST_TRIPLET}-strip"
# export RC="${HOST_TRIPLET}-windres"
# export WINDRES="${HOST_TRIPLET}-windres"

export MINGW64_DIR='C:/mingw-w64/i686-4.9.2-posix-sjlj-rt_v3-rev1/mingw32'
export WIN_BUILDS_DIR='C:/win-builds'
export CYGWIN_DIR='C:/cygwin'

export AR="${MINGW64_DIR}/bin/ar"
export AS="${MINGW64_DIR}/bin/as"
export CC="${MINGW64_DIR}/bin/gcc"
export CXX="${MINGW64_DIR}/bin/g++"
export DLLTOOL="${MINGW64_DIR}/bin/dlltool"
export LD="${MINGW64_DIR}/bin/ld"
export NM="${MINGW64_DIR}/bin/nm"
export OBJCOPY="${MINGW64_DIR}/bin/objcopy"
export OBJDUMP="${MINGW64_DIR}/bin/objdump"
export RANLIB="${MINGW64_DIR}/bin/ranlib"
export STRIP="${MINGW64_DIR}/bin/strip"
export RC="${MINGW64_DIR}/bin/windres"
export WINDRES="${MINGW64_DIR}/bin/windres"

export PREFIX=""
export CFLAGS="-I${BUILD_DIR}/include -I${BUILD_DIR}/include -I${MINGW64_DIR}/include"
export CPPFLAGS="-I${BUILD_DIR}/include"
export CXXFLAGS="-I${BUILD_DIR}/include"
export LDFLAGS="-L${BUILD_DIR}/bin -L${BUILD_DIR}/lib"
# export ARFLAGS="rcs"
# export RCFLAGS="--define=GCC_WINDRES"
# export PKG_CONFIG="${WIN_BUILDS_DIR}/bin/pkg-config"
# export PKG_CONFIG_PATH="${BUILD_DIR}/lib/pkgconfig:${WIN_BUILDS_DIR}/lib/pkgconfig"
export PKG_CONFIG_PATH="${BUILD_DIR}/lib/pkgconfig"
# export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig"
# export PKG_CONFIG_SYSROOT_DIR="$PREFIX"

export PACKAGE_TARNAME="mingw-w64-builds.tar"
export PACKAGE_FILENAME="mingw-w64-builds.tar.xz"

