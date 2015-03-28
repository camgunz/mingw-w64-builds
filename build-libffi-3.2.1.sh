#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
ARCHIVE_NAME="libffi-3.2.1.tar.gz"
TARBALL_NAME="libffi-3.2.1.tar"
SOURCE_DIR_NAME="libffi-3.2.1"

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
            --enable-static || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

