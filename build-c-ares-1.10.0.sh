#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://c-ares.haxx.se/download/c-ares-1.10.0.tar.gz"
ARCHIVE_NAME="c-ares-1.10.0.tar.gz"
TARBALL_NAME="c-ares-1.10.0.tar"
SOURCE_DIR_NAME="c-ares-1.10.0"

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
export CFLAGS=""
./configure --prefix="" \
            --enable-shared \
            --enable-static \
            --enable-nonblocking \
            || exit 1

make -j 1 || exit 1
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

