#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="https://github.com/json-c/json-c.git"
SOURCE_DIR_NAME="json-c"

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
             || exit 1
make || exit 1
make DESTDIR=${BUILD_DIR} install || exit 1

popd > /dev/null
popd > /dev/null

