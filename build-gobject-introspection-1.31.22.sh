#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/1.31/gobject-introspection-1.31.22.tar.xz"
ARCHIVE_NAME="gobject-introspection-1.31.22.tar.xz"
TARBALL_NAME="gobject-introspection-1.31.22.tar"
SOURCE_DIR_NAME="gobject-introspection-1.31.22"

pushd ${ARCHIVE_DIR} > /dev/null
curl --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

xz -d ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null
export PYTHON="${MINGW64_DIR}/opt/bin/python"
export CFLAGS="-I${BUILD_DIR}/include"
export CPPFLAGS="-I${BUILD_DIR}/include"
export SCANNER_CFLAGS="-I${BUILD_DIR}/include"
export LDFLAGS="${LDFLAGS} -L${MINGW64_DIR}/opt/bin"

cp ${BUILD_DIR}/lib/libgobject-2.0.la /lib/libgobject-2.0.la || exit 1
cp ${BUILD_DIR}/lib/libgmodule-2.0.la /lib/libgmodule-2.0.la || exit 1
cp ${BUILD_DIR}/lib/libgobject-2.0.dll.a /lib/libgobject-2.0.dll.a
cp ${BUILD_DIR}/lib/libgmodule-2.0.dll.a /lib/libgmodule-2.0.dll.a
cp ${BUILD_DIR}/lib/libglib-2.0.dll.a /lib/libglib-2.0.dll.a
cp ${BUILD_DIR}/lib/../lib/libffi.dll.a /lib/../lib/libffi.dll.a

SCANNER_CFLAGS="-I${BUILD_DIR}/include" CFLAGS="-I${BUILD_DIR}/include" CPPFLAGS="-I${BUILD_DIR}/include" \
    ./configure || exit 1
SCANNER_CFLAGS="-I${BUILD_DIR}/include" CFLAGS="-I${BUILD_DIR}/include" CPPFLAGS="-I${BUILD_DIR}/include" \
    make V=1 VERBOSE=1 || exit 1
SCANNER_CFLAGS="-I${BUILD_DIR}/include" CFLAGS="-I${BUILD_DIR}/include" CPPFLAGS="-I${BUILD_DIR}/include" \
    make DESTDIR=${BUILD_DIR} install || exit 1
popd > /dev/null

popd > /dev/null

