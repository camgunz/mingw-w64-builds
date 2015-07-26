#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="https://www.github.com/pavouk/lgi"
SOURCE_DIR_NAME="lgi"

pushd ${SOURCE_DIR} > /dev/null

if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

${GIT} clone ${URL}

pushd ${SOURCE_DIR_NAME} > /dev/null

export DESTDIR="${BUILD_DIR}"
export LUA_VERSION="5.3"
export CFLAGS="$CFLAGS $(pkg-config gobject-introspection-1.0 --cflags)"
export LDFLAGS="$LDFLAGS $(pkg-config gobject-introspection-1.0 --libs)"
export LDFLAGS="$LDFLAGS -L${BUILD_DIR}/bin"
# export LDFLAGS="$LDFLAGS ${BUILD_DIR}/lib/liblua.a"

make || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

