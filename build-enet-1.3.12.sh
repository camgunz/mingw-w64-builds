#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL='http://enet.bespin.org/download/enet-1.3.12.tar.gz'
ARCHIVE_NAME='enet-1.3.12.tar.gz'
TARBALL_NAME='enet-1.3.12.tar'
SOURCE_DIR_NAME='enet-1.3.12'

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name -L ${URL} || exit 1
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
./configure \
    --enable-shared \
    --enable-static \
    --prefix="" \
    || exit 1
make
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

