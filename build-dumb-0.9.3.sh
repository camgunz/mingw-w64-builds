#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL='http://downloads.sourceforge.net/project/dumb/dumb/0.9.3/dumb-0.9.3.tar.gz'
ARCHIVE_NAME='dumb-0.9.3.tar.gz'
TARBALL_NAME='dumb-0.9.3.tar'
SOURCE_DIR_NAME='dumb-0.9.3'

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

unset COMSPEC

echo 'include make/unix.inc' > make/config.txt
echo 'ALL_TARGETS := core core-examples core-headers' >> make/config.txt
echo "PREFIX := ${BUILD_DIR}" >> make/config.txt

make -j 1 && make DESTDIR=${BUILD_DIR} install || exit 1

popd > /dev/null
popd > /dev/null

