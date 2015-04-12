#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL='https://webp.googlecode.com/files/libwebp-0.4.0.tar.gz'
ARCHIVE_NAME='libwebp-0.4.0.tar.gz'
TARBALL_NAME='libwebp-0.4.0.tar'
SOURCE_DIR_NAME='libwebp-0.4.0'

pushd ${ARCHIVE_DIR} > /dev/null
curl -k --retry 5 --remote-name -L ${URL} || exit 1
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

cp ${BUILD_DIR}/lib/liblzma.la /lib/liblzma.la
cp ${BUILD_DIR}/lib/libjpeg.la /lib/libjpeg.la
cp ${BUILD_DIR}/lib/liblzma.dll.a /lib/liblzma.dll.a
cp ${BUILD_DIR}/lib/libjpeg.dll.a /lib/libjpeg.dll.a

./configure \
    --enable-shared \
    --enable-static \
    --prefix="" \
    || exit 1
make -j 1
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

