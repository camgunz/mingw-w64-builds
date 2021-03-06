#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz"
ARCHIVE_NAME="libiconv-1.14.tar.gz"
TARBALL_NAME="libiconv-1.14.tar"
SOURCE_DIR_NAME="libiconv-1.14"

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
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

patch -p0 -i ${PATCH_DIR}/libiconv-1.14-compile-relocatable-in-gnulib.patch || exit 1
patch -p0 -i ${PATCH_DIR}/libiconv-1.14-fix-cr-for-awk-in-configure.patch || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

./configure --enable-extra-encodings \
            --enable-nls \
            --enable-silent-rules \
            --enable-relocatable \
            --disable-rpath \
            --enable-shared \
            --enable-static \
            || exit 1
make || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

