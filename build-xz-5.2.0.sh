#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://tukaani.org/xz/xz-5.2.0.tar.bz2"
ARCHIVE_NAME="xz-5.2.0.tar.bz2"
TARBALL_NAME="xz-5.2.0.tar"
SOURCE_DIR_NAME="xz-5.2.0"

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

bunzip2 ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null
./configure \
    --enable-shared \
    --enable-static \
    --disable-assembler \
    --prefix="" \
    || exit 1
make -j 1
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

