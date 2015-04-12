#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

# URL="ftp://xmlsoft.org/libxslt/libxslt-1.1.28.tar.gz"
# ARCHIVE_NAME="libxslt-1.1.28.tar.gz"
# TARBALL_NAME="libxslt-1.1.28.tar"
# SOURCE_DIR_NAME="libxslt-1.1.28"

URL="git://git.gnome.org/libxslt"
SOURCE_DIR_NAME="libxslt"

# pushd ${ARCHIVE_DIR} > /dev/null
# curl --retry 5 --remote-name -L ${URL} || exit 1
# popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

${GIT} clone ${URL}

# gunzip ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
# tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
# rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

patch -p1 -f -i ${PATCH_DIR}/libxslt-1.1.28-use-win32config-on-msys.patch

cp ${SOURCE_DIR}/libxml2/xml2-config ${BUILD_DIR}/bin/xml2-config
sed -i "s:prefix='':prefix='${BUILD_DIR}':g" ${BUILD_DIR}/bin/xml2-config

export CFLAGS="$CFLAGS -DLIBXML_STATIC -DLIBXSLT_STATIC -DLIBEXSLT_STATIC"
export CPPFLAGS="$CPPFLAGS -DLIBXML_STATIC -DLIBXSLT_STATIC -DLIBEXSLT_STATIC"

./autogen.sh --prefix='' \
             --enable-static \
             --enable-shared \
             --with-libxml-prefix=${BUILD_DIR} \
             --with-libxml-include-prefix=${BUILD_DIR}/include \
             --with-libxml-libs-prefix=${BUILD_DIR}/lib \

if [ $? -ne 0 ]
then
    sed -i "s:prefix='${BUILD_DIR}':prefix='':g" ${BUILD_DIR}/bin/xml2-config
    exit 1
fi

CFLAGS="$CFLAGS -DLIBXML_STATIC -DLIBXSLT_STATIC -DLIBEXSLT_STATIC" \
V=1 \
make

if [ $? -ne 0 ]
then
    sed -i "s:prefix='${BUILD_DIR}':prefix='':g" ${BUILD_DIR}/bin/xml2-config
    exit 1
fi

CFLAGS="$CFLAGS -DLIBXML_STATIC -DLIBXSLT_STATIC -DLIBEXSLT_STATIC" \
V=1 \
DESTDIR=${BUILD_DIR} \
make install

if [ $? -ne 0 ]
then
    sed -i "s:prefix='${BUILD_DIR}':prefix='':g" ${BUILD_DIR}/bin/xml2-config
    exit 1
fi

sed -i "s:prefix='${BUILD_DIR}':prefix='':g" ${BUILD_DIR}/bin/xml2-config

# patch -p1 -f -i ${PATCH_DIR}/libxslt-1.1.28-use-posix-shell-commands.patch
# 
# pushd win32 > /dev/null
# export PYTHON="${MINGW64_DIR}/opt/bin/python"
# export LDFLAGS="${LDFLAGS} -L${MINGW64_DIR}/opt/bin"
# cscript configure.js prefix=${BUILD_DIR} \
#                      bindir=${BUILD_DIR}/bin \
#                      incdir=${BUILD_DIR}/include \
#                      libdir=${BUILD_DIR}/lib \
#                      sodir=${BUILD_DIR}/bin \
#                      compiler=mingw \
#                      static=yes \
#                      zlib=yes \
#                      || exit 1
# make -f Makefile.mingw || exit 1
# make -f Makefile.mingw DESTDIR=${BUILD_DIR} install || exit 1
# 
# popd > /dev/null

popd > /dev/null

