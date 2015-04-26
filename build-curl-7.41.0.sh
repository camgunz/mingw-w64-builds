#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://curl.haxx.se/download/curl-7.41.0.tar.bz2"
ARCHIVE_NAME="curl-7.41.0.tar.bz2"
TARBALL_NAME="curl-7.41.0.tar"
SOURCE_DIR_NAME="curl-7.41.0"

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

export CFLAGS="$CFLAGS -DCURL_STATICLIB"

#             --with-polarssl=$PREFIX \
./configure --prefix="" \
            --disable-shared \
            --enable-static \
            --enable-ares=${BUILD_DIR} \
            --enable-ipv6 \
            --with-winidn \
            --disable-threaded-resolver \
            || exit 1
make -j 1
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

