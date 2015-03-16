#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://github.com/behdad/harfbuzz"
SOURCE_DIR_NAME="harfbuzz"

pushd ${SOURCE_DIR} > /dev/null

# if [ -d ${SOURCE_DIR_NAME} ]
# then
#     rm -rf ${SOURCE_DIR_NAME}
# fi
# 
# git clone ${URL} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

cp ${BUILD_DIR}/lib/libintl.la /lib
cp ${BUILD_DIR}/lib/libpng15.la /lib
cp ${BUILD_DIR}/lib/libintl.dll.a /lib
cp ${BUILD_DIR}/lib/libpng15.dll.a /lib

# ./autogen.sh --enable-shared \
#              --enable-static \
#              --prefix="" \
#              || exit 1
make || exit 1
make DESTDIR=${BUILD_DIR} install || exit 1

popd > /dev/null
popd > /dev/null

