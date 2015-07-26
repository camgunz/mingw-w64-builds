#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.1.tar.bz2"
ARCHIVE_NAME="fontconfig-2.11.1.tar.bz2"
TARBALL_NAME="fontconfig-2.11.1.tar"
SOURCE_DIR_NAME="fontconfig-2.11.1"

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name --insecure -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

tar xf ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

./configure --enable-shared \
            --enable-static \
            --prefix="${BUILD_DIR}"

make && make install

popd > /dev/null
popd > /dev/null

