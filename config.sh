#!/bin/bash

export BASE_DIR="`pwd`"
export ARCHIVE_DIR=${BASE_DIR}/archives
export SOURCE_DIR=${BASE_DIR}/source
export PATCH_DIR=${BASE_DIR}/patches
export BUILD_DIR=${BASE_DIR}/build
export PATH=${BUILD_DIR}/bin:$PATH

# export MINGW64_DIR='C:/mingw-w64/i686-4.9.2-posix-sjlj-rt_v3-rev1/mingw32'
export MINGW64_DIR='/c/mingw-w64/i686-4.9.2-posix-sjlj-rt_v3-rev1/mingw32'

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
export CPPFLAGS="-I${BUILD_DIR}/include -I${BUILD_DIR}/include -I${MINGW64_DIR}/include"
export CXXFLAGS="-I${BUILD_DIR}/include"
export LDFLAGS="-L${BUILD_DIR}/bin -L${BUILD_DIR}/lib"
export PKG_CONFIG_PATH="${BUILD_DIR}/lib/pkgconfig"
# export PKG_CONFIG_LIBDIR="$PREFIX/lib/pkgconfig"
# export PKG_CONFIG_SYSROOT_DIR="$PREFIX"
# export ARFLAGS="rcs"

export PACKAGE_TARNAME="mingw-w64-builds.tar"
export PACKAGE_FILENAME="mingw-w64-builds.tar.xz"

export PATH=.:/usr/local/bin:/mingw/bin:/bin:/c/Windows/system32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/:/c/Users/Charlie/Apps:/c/mingw-w64/i686-4.9.2-posix-sjlj-rt_v3-rev1/mingw32/bin:/usr/bin

