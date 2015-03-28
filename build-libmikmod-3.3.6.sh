#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL='http://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.6/libmikmod-3.3.6.tar.gz'
ARCHIVE_NAME='libmikmod-3.3.6.tar.gz'
TARBALL_NAME='libmikmod-3.3.6.tar'
SOURCE_DIR_NAME='libmikmod-3.3.6'

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

./configure --enable-shared \
            --enable-static \
            --enable-aiff \
            --enable-wav \
            --enable-raw \
            --enable-stdout \
            --enable-pipe \
            --enable-openal \
            --enable-win \
            --enable-xaudio2 \
            || exit 1

make || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

