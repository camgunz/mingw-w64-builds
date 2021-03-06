#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://github.com/pavouk/lgi"
SOURCE_DIR_NAME="lgi"

pushd ${SOURCE_DIR} > /dev/null

if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

git clone ${URL} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

make || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

