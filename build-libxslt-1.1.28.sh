#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="ftp://xmlsoft.org/libxslt/libxslt-1.1.28.tar.gz"
ARCHIVE_NAME="libxslt-1.1.28.tar.gz"
TARBALL_NAME="libxslt-1.1.28.tar"
SOURCE_DIR_NAME="libxslt-1.1.28"

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

patch -p1 -f -i ${PATCH_DIR}/libxslt-1.1.28-use-win32config-on-msys.patch

cp ${SOURCE_DIR}/libxml2-2.9.2/xml2-config /bin/xml2-config
sed -i "s:prefix='':prefix='${PREFIX}':g" /bin/xml2-config

./configure --enable-static \
            --enable-shared \
            || exit 1

if [ $? -ne 0 ]
then
    sed -i "s:prefix='${PREFIX}':prefix='':g" /bin/xml2-config
    exit 1
fi

make

if [ $? -ne 0 ]
then
    sed -i "s:prefix='${PREFIX}':prefix='':g" /bin/xml2-config
    exit 1
fi

make install

if [ $? -ne 0 ]
then
    sed -i "s:prefix='${PREFIX}':prefix='':g" /bin/xml2-config
    exit 1
fi

sed -i "s:prefix='${PREFIX}':prefix='':g" /bin/xml2-config \
    || exit 1

popd > /dev/null

