#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

export XML_CATALOG_FILES="${BUILD_DIR}/etc/xml/catalog"

URL="ftp://ftp.gnome.org/pub/GNOME/sources/gtk-doc/1.21/gtk-doc-1.21.tar.xz"
ARCHIVE_NAME="gtk-doc-1.21.tar.xz"
TARBALL_NAME="gtk-doc-1.21.tar"
SOURCE_DIR_NAME="gtk-doc-1.21"

pushd ${ARCHIVE_DIR} > /dev/null
curl --retry 5 --remote-name -L ${URL} || exit 1
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
export PYTHON="${MINGW64_DIR}/opt/bin/python"
export LDFLAGS="${LDFLAGS} -L${MINGW64_DIR}/opt/bin"
./configure --enable-shared \
            --enable-static \
            --prefix="" \
            --with-xml-catalog=${BUILD_DIR}/etc/xml/catalog \
            || exit 1
make || exit 1
make DESTDIR=${BUILD_DIR} install || exit 1

cp ${BUILD_DIR}/share/aclocal/gtk-doc.m4 /share/aclocal/gtk-doc.m4 || exit 1
cp -R ${BUILD_DIR}/share/gtk-doc /share/ || exit 1

popd > /dev/null
popd > /dev/null

