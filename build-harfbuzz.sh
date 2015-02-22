#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://github.com/behdad/harfbuzz"
SOURCE_DIR_NAME="harfbuzz"

# pushd ${ARCHIVE_DIR} > /dev/null
# curl --retry 5 --remote-name -L ${URL} || exit 1
# popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

git clone ${URL} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null
./autogen.sh --enable-shared \
             --enable-static \
             --prefix="" \
             --enable-gtk-doc=no \
             || exit 1
make || exit 1
make DESTDIR=${BUILD_DIR} install || exit 1

popd > /dev/null
popd > /dev/null

