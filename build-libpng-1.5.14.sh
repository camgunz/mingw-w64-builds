#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://downloads.sourceforge.net/project/libpng/libpng15/older-releases/1.5.14/libpng-1.5.14.tar.xz"
ARCHIVE_NAME="libpng-1.5.14.tar.xz"
TARBALL_NAME="libpng-1.5.14.tar"
SOURCE_DIR_NAME="libpng-1.5.14"

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
./configure --enable-shared --enable-static || exit 1
make || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

