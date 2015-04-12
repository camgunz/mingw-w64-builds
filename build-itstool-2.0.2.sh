#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

export PYTHON="${MINGW64_DIR}/opt/bin/python"
export PATH="${MINGW64_DIR}/opt/bin:$PATH"
# export PYTHONPATH="${MINGW64_DIR}/opt/lib/python2.7/site-packages/libxmlmods"

URL='http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2'
ARCHIVE_NAME='itstool-2.0.2.tar.bz2'
TARBALL_NAME='itstool-2.0.2.tar'
SOURCE_DIR_NAME='itstool-2.0.2'

# cp "${BUILD_DIR}/bin/libiconv-2.dll" "${BUILD_DIR}/bin/iconv.dll"
# cp "${BUILD_DIR}/bin/libxslt-1.dll"  "${BUILD_DIR}/bin/libxslt.dll"
# cp "${BUILD_DIR}/bin/libexslt-0.dll" "${BUILD_DIR}/bin/libexslt.dll"
# 
# cp "${BUILD_DIR}/bin/iconv.dll"     "${PYTHON_SITE_PACKAGES}/"
# cp "${BUILD_DIR}/bin/libexslt.dll"  "${PYTHON_SITE_PACKAGES}/"
# cp "${BUILD_DIR}/bin/liblzma-5.dll" "${PYTHON_SITE_PACKAGES}/"
# cp "${PYTHON_DIR}/libpython2.7.dll" "${PYTHON_SITE_PACKAGES}/"
# cp "${BUILD_DIR}/bin/libxml2.dll"   "${PYTHON_SITE_PACKAGES}/"
# cp "${BUILD_DIR}/bin/libxslt.dll"   "${PYTHON_SITE_PACKAGES}/"
# cp "${BUILD_DIR}/bin/zlib1.dll"     "${PYTHON_SITE_PACKAGES}/"
# 
# cp "${PYTHON_SITE_PACKAGES}/drv_libxml2.py"   "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/drv_libxml2.pyc"  "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/iconv.dll"        "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/libexslt.dll"     "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/liblzma-5.dll"    "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/libpython2.7.dll" "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/libxml2.dll"      "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/libxml2.py"       "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/libxml2.pyc"      "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/libxml2mod.pyd"   "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/libxslt.dll"      "${PYTHON_SITE_PACKAGES}/libxmlmods/"
# cp "${PYTHON_SITE_PACKAGES}/zlib1.dll"        "${PYTHON_SITE_PACKAGES}/libxmlmods/"

pushd ${ARCHIVE_DIR} > /dev/null
${CURL} --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

bunzip2 ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null
cp -R "${PYTHON_SITE_PACKAGES}"/libxmlmods/* . || exit 1

./configure --prefix="" || exit 1
make -j 1 || exit 1
make DESTDIR=${BUILD_DIR} install || exit 1

popd > /dev/null
popd > /dev/null

