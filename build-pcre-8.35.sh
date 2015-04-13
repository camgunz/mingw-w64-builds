#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.bz2"
ARCHIVE_NAME="pcre-8.35.tar.bz2"
TARBALL_NAME="pcre-8.35.tar"
SOURCE_DIR_NAME="pcre-8.35"

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
./configure --prefix="" \
            --enable-unicode-properties \
            --enable-newline-is-any \
            --enable-shared \
            --enable-static || exit 1
make DESTDIR=${BUILD_DIR} install || exit 1

popd > /dev/null
popd > /dev/null

