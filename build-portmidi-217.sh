#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
ARCHIVE_NAME="portmidi-src-217.zip"
SOURCE_DIR_NAME="portmidi"

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

unzip -q ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

patch -p0 -f -i "${PATCH_DIR}/portmidi-217.patch"

if [ -d pbuild ]
then
  rm -rf pbuild || exit 1
fi

mkdir pbuild || exit 1
pushd pbuild > /dev/null

cmake .. -G"Unix Makefiles" \
         -DCMAKE_INSTALL_PREFIX="$PREFIX" \
         -DCMAKE_CACHEFILE_DIR="${SOURCE_DIR_NAME}/pbuild" \
         || exit 1;
make && \
  cp libportmidi.dll.a libportmidi_s.a "${BUILD_DIR}/lib" &&
  cp libportmidi.dll "${BUILD_DIR}/bin" &&
  cp ../pm_common/portmidi.h ../porttime/porttime.h "${BUILD_DIR}/include" \
  || exit 1

popd > /dev/null
popd > /dev/null
popd > /dev/null

