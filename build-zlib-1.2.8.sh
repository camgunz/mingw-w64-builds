#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

export LD="gcc"

URL="http://zlib.net/zlib-1.2.8.tar.gz"
ARCHIVE_NAME="zlib-1.2.8.tar.gz"
TARBALL_NAME="zlib-1.2.8.tar"
SOURCE_DIR_NAME="zlib-1.2.8"

pushd ${ARCHIVE_DIR} > /dev/null
curl --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

gunzip ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null
cp ${SOURCE_DIR}/${SOURCE_DIR_NAME}/win32/Makefile.gcc \
   ${SOURCE_DIR}/${SOURCE_DIR_NAME}/win32/Makefile.gcc.orig
patch -p1 -f -i ${PATCH_DIR}/zlib-1.2.8-fix-win32-makefile.patch || exit 1
make -f win32/Makefile.gcc || exit 1
cp zlib1.dll minigzip.exe ${BUILD_DIR}/bin || exit 1
cp libz.dll.a libz.a ${BUILD_DIR}/lib || exit 1
cp zlib.h zconf.h ${BUILD_DIR}/include || exit 1

popd > /dev/null
popd > /dev/null

