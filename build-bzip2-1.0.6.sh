#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
ARCHIVE_NAME="bzip2-1.0.6.tar.gz"
TARBALL_NAME="bzip2-1.0.6.tar"
SOURCE_DIR_NAME="bzip2-1.0.6"

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

patch -p0 -i ${PATCH_DIR}/bzip2-1.0.6-bzip2recover.patch || exit 1
patch -p0 -i ${PATCH_DIR}/bzip2-1.0.6-slash.patch || exit 1
patch -p0 -i ${PATCH_DIR}/bzip2-1.0.6-bzgrep.patch || exit 1
patch -p0 -i ${PATCH_DIR}/bzip2-1.0.6-buildsystem.patch || exit 1
patch -p0 -i ${PATCH_DIR}/bzip2-1.0.6-progress.patch || exit 1
patch -p0 -i ${PATCH_DIR}/bzip2-1.0.6-stdio-fixes.patch || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

autoreconf -fi || exit 1
./configure --enable-shared || exit 1
make all-dll-shared || exit 1
make -k check
make install

popd > /dev/null
popd > /dev/null

