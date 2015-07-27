#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL='http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.xz'
ARCHIVE_NAME='libvorbis-1.3.4.tar.xz'
TARBALL_NAME='libvorbis-1.3.4.tar'
SOURCE_DIR_NAME='libvorbis-1.3.4'

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name -L ${URL} || exit 1
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
./configure \
    --enable-shared \
    --enable-static \
    --prefix="" \
    --with-ogg="${BUILD_DIR}" \
    || exit 1
make
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

