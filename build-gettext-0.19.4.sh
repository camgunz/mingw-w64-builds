#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.4.tar.xz"
ARCHIVE_NAME="gettext-0.19.4.tar.xz"
TARBALL_NAME="gettext-0.19.4.tar"
SOURCE_DIR_NAME="gettext-0.19.4"

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

./configure CFLAGS="-O2" \
            CPPFLAGS="-O2" \
            CXXFLAGS="-O2" \
            --with-threads=posix \
            --enable-shared \
            --enable-static \
            --with-included-libcroco \
            --with-included-libunistring \
            --with-included-libxml \
            --with-included-glib \
            || exit 1
make || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

