#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://www.lua.org/ftp/lua-5.3.1.tar.gz"
ARCHIVE_NAME="lua-5.3.1.tar.gz"
TARBALL_NAME="lua-5.3.1.tar"
SOURCE_DIR_NAME="lua-5.3.1"

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name -L ${URL} || exit 1
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
export CPPFLAGS="$CPPFLAGS -DLUA_BUILD_AS_DLL"
make INSTALL_TOP=${BUILD_DIR} mingw install

cp src/lua53.dll ${BUILD_DIR}/bin

# mv /usr/local/include/lua.h ${BUILD_DIR}/include/ || exit 1
# mv /usr/local/include/luaconf.h ${BUILD_DIR}/include/ || exit 1
# mv /usr/local/include/lualib.h ${BUILD_DIR}/include/ || exit 1
# mv /usr/local/include/lauxlib.h ${BUILD_DIR}/include/ || exit 1
# mv /usr/local/include/lua.hpp ${BUILD_DIR}/include/ || exit 1
# mv /usr/local/lib/liblua.a ${BUILD_DIR}/lib/ || exit 1

popd > /dev/null
popd > /dev/null

