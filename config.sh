#!/bin/bash

# export BIN_DIR="/usr/bin"
# export BUILD_TRIPLET="x86_64-pc-linux-gnu"
# export HOST_TRIPLET="i686-w64-mingw32"
# export HOST_PREFIX="/usr/$HOST_TRIPLET"

export BASE_DIR=`pwd`
export ARCHIVE_DIR=${BASE_DIR}/archives
export SOURCE_DIR=${BASE_DIR}/source
export PATCH_DIR=${BASE_DIR}/patches
# export MODULES_DIR=${BASE_DIR}/modules
export BUILD_DIR=${BASE_DIR}/build
export PATH=${BUILD_DIR}/bin:$PATH

export AR="ar"
export CC="gcc"
# export CXX="$BIN_DIR/$HOST_TRIPLET-g++"
# export DLLTOOL="$BIN_DIR/$HOST_TRIPLET-dlltool"
# export LD="gcc"
# export NM="$BIN_DIR/$HOST_TRIPLET-nm"
# export OBJCOPY="$BIN_DIR/$HOST_TRIPLET-objcopy"
# export OBJDUMP="$BIN_DIR/$HOST_TRIPLET-objdump"
export RANLIB="ranlib"
export STRIP="strip"
export RC="windres"
export WINDRES="windres"

export PREFIX=""
# export LUA_INCLUDE_DIR="$HOST_PREFIX/include/lua5.1"
export CFLAGS="-I${BUILD_DIR}/include"
export CPPFLAGS="-I${BUILD_DIR}/include"
export CXXFLAGS="-I${BUILD_DIR}/include"
export LDFLAGS="-L${BUILD_DIR}/bin -L${BUILD_DIR}/lib"
# export ARFLAGS="rcs"
# export RCFLAGS="--define=GCC_WINDRES"
export PATH="${BUILD_DIR}/bin":$PATH
# export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
# export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig"
# export PKG_CONFIG_SYSROOT_DIR="$PREFIX"

export PACKAGE_TARNAME="msys-builds.tar"
export PACKAGE_FILENAME="msys-builds.tar.xz"

