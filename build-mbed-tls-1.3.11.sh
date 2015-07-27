#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="https://tls.mbed.org/download/mbedtls-1.3.11-gpl.tgz"
ARCHIVE_NAME="mbedtls-1.3.11-gpl.tgz"
TARBALL_NAME="mbedtls-1.3.11-gpl.tar"
SOURCE_DIR_NAME="mbedtls-1.3.11"

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

patch -p0 -f -i "${PATCH_DIR}/mbedtls-1.3.11-copy-to-ln.patch"

pushd ${SOURCE_DIR_NAME} > /dev/null

make WINDOWS=1
make WINDOWS=1 DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

