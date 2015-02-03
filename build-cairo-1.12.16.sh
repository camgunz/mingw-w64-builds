#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://cairographics.org/releases/cairo-1.12.16.tar.xz"
ARCHIVE_NAME="cairo-1.12.16.tar.xz"
TARBALL_NAME="cairo-1.12.16.tar"
SOURCE_DIR_NAME="cairo-1.12.16"

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
./configure --enable-shared --enable-static --prefix=""
make
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

