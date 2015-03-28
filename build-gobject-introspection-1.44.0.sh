#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/1.44/gobject-introspection-1.44.0.tar.xz"
ARCHIVE_NAME="gobject-introspection-1.44.0.tar.xz"
TARBALL_NAME="gobject-introspection-1.44.0.tar"
SOURCE_DIR_NAME="gobject-introspection-1.44.0"

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
export CFLAGS="-I/include"
export CPPFLAGS="-I/include"
export SCANNER_CFLAGS="-I/include"
export LDFLAGS="${LDFLAGS} -L${MINGW64_DIR}/opt/bin"

# patch -p1 -f -i ${PATCH_DIR}/gobject-introspection-win32-2.patch || exit 1

CFLAGS="-I/include"  \
CPPFLAGS="-I/include" \
SCANNER_CFLAGS="-I/include" \
    ./configure || exit 1

CFLAGS="-I/include" \
CPPFLAGS="-I/include" \
SCANNER_CFLAGS="-I/include" \
    make V=1 VERBOSE=1 || exit 1

CFLAGS="-I/include" \
CPPFLAGS="-I/include" \
SCANNER_CFLAGS="-I/include" \
    make install || exit 1

popd > /dev/null
popd > /dev/null

