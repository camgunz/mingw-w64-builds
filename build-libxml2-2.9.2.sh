#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

export PYTHON="${MINGW64_DIR}/opt/bin/python"

PYTHON_SITE_PACKAGES="${MINGW64_DIR}/opt/lib/python2.7/site-packages"

URL="ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz"
ARCHIVE_NAME="libxml2-2.9.2.tar.gz"
TARBALL_NAME="libxml2-2.9.2.tar"
SOURCE_DIR_NAME="${SOURCE_DIR}/libxml2-2.9.2"

pushd ${ARCHIVE_DIR} > /dev/null
echo "Downloading"
curl --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

gunzip ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null
cp configure.ac configure.in
# cp win32/Makefile.mingw win32/Makefile.mingw.orig
patch -p1 -f -i ${PATCH_DIR}/libxml2-2.9.2-use-posix-shell-commands.patch
patch -p1 -f -i ${PATCH_DIR}/libxml2-2.9.2-make-xml2-config-file-manually.patch

pushd ${SOURCE_DIR_NAME}/win32 > /dev/null
cscript configure.js threads=no \
                     http=no \
                     zlib=yes \
                     lzma=yes \
                     python=yes \
                     compiler=mingw \
                     prefix=${BUILD_DIR} \
                     bindir=${BUILD_DIR}/bin \
                     incdir=${BUILD_DIR}/include \
                     libdir=${BUILD_DIR}/lib \
                     sodir=${BUILD_DIR}/bin \
                     || exit 1
export CFLAGS="$CFLAGS -DHAVE_STDINT_H=1 -DLIBXML_STATIC"
make -f Makefile.mingw || exit 1
make -f Makefile.mingw DESTDIR=${BUILD_DIR} install || exit 1
popd > /dev/null

cp xml2-config ${BUILD_DIR}/bin/ || exit 1

popd > /dev/null

pushd ${SOURCE_DIR_NAME}/python > /dev/null
cp ${BUILD_DIR}/bin/libiconv-2.dll ${BUILD_DIR}/bin/iconv.dll || exit 1
cp ${BUILD_DIR}/bin/libxslt-1.dll ${BUILD_DIR}/bin/libxslt.dll || exit 1
cp ${BUILD_DIR}/bin/libexslt-0.dll ${BUILD_DIR}/bin/libexslt.dll || exit 1

LDFLAGS=-L${MINGW64_DIR}/opt/bin ${PYTHON} setup.py install

cp "${MINGW64_DIR}/opt/lib/site-packages/libxmlmods/iconv.dll"    "${PYTHON_SITE_PACKAGES}/libxmlmods/" || exit 1
cp "${MINGW64_DIR}/opt/lib/site-packages/libxmlmods/libxslt.dll"  "${PYTHON_SITE_PACKAGES}/libxmlmods/" || exit 1
cp "${MINGW64_DIR}/opt/lib/site-packages/libxmlmods/libexslt.dll" "${PYTHON_SITE_PACKAGES}/libxmlmods/" || exit 1
cp "${MINGW64_DIR}/opt/lib/site-packages/libxmlmods/libxml2.dll"  "${PYTHON_SITE_PACKAGES}/libxmlmods/" || exit 1
cp "${BUILD_DIR}/bin/liblzma-5.dll"                               "${PYTHON_SITE_PACKAGES}/libxmlmods/" || exit 1
cp "${BUILD_DIR}/bin/zlib1.dll"                                   "${PYTHON_SITE_PACKAGES}/libxmlmods/" || exit 1

cp "${PYTHON_SITE_PACKAGES}/libxmlmods/iconv.dll"                 "${PYTHON_SITE_PACKAGES}/"            || exit 1
cp "${PYTHON_SITE_PACKAGES}/libxmlmods/libxslt.dll"               "${PYTHON_SITE_PACKAGES}/"            || exit 1
cp "${PYTHON_SITE_PACKAGES}/libxmlmods/libexslt.dll"              "${PYTHON_SITE_PACKAGES}/"            || exit 1
cp "${PYTHON_SITE_PACKAGES}/libxmlmods/libxml2.dll"               "${PYTHON_SITE_PACKAGES}/"            || exit 1
cp "${BUILD_DIR}/bin/liblzma-5.dll"                               "${PYTHON_SITE_PACKAGES}/"            || exit 1
cp "${BUILD_DIR}/bin/zlib1.dll"                                   "${PYTHON_SITE_PACKAGES}/"            || exit 1
cp "${PYTHON_SITE_PACKAGES}/libxmlmods/libxml2mod.pyd"            "${PYTHON_SITE_PACKAGES}/"            || exit 1

popd > /dev/null

# popd > /dev/null

