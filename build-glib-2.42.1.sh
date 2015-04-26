#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://ftp.gnome.org/pub/gnome/sources/glib/2.44/glib-2.44.0.tar.xz"
ARCHIVE_NAME="glib-2.44.0.tar.xz"
TARBALL_NAME="glib-2.44.0.tar"
SOURCE_DIR_NAME="glib-2.44.0"

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

xz -d ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null
sed -i "s|#undef HAVE_IF_NAMETOINDEX|#define HAVE_IF_NAMETOINDEX 1|g" config.h.in
./configure --prefix='' PYTHON=${MINGW64_DIR}/opt/bin/python
make
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

