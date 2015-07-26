#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://downloads.sourceforge.net/project/fluidsynth/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.bz2"
ARCHIVE_NAME="fluidsynth-1.1.6.tar.bz2"
TARBALL_NAME="fluidsynth-1.1.6.tar"
SOURCE_DIR_NAME="fluidsynth-1.1.6"

if [ ! -f "${ARCHIVE_DIR}/${ARCHIVE_NAME}" ]
then
    pushd ${ARCHIVE_DIR} > /dev/null
    ${CURL} --retry 5 --remote-name -L ${URL} || exit 1
    popd > /dev/null
fi

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

if [ ! -f "${ARCHIVE_DIR}/${TARBALL_NAME}" ]
then
    bunzip2 ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
fi

tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
# rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

echo "SET(CMAKE_SYSTEM_NAME Windows)" > mingw64-toolchain.cmake
echo "SET(CMAKE_C_COMPILER $CC)" >> mingw64-toolchain.cmake
echo "SET(CMAKE_C_COMPILER_ENV_VAR $CC)" >> mingw64-toolchain.cmake
echo "SET(CMAKE_CXX_COMPILER $CXX)" >> mingw64-toolchain.cmake
echo "SET(CMAKE_RC_COMPILER $WINDRES)" >> mingw64-toolchain.cmake
# echo "SET(CMAKE_FIND_ROOT_PATH $HOST_PREFIX)" >> mingw64-toolchain.cmake

echo "SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> mingw64-toolchain.cmake
echo "SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> mingw64-toolchain.cmake
echo "SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> mingw64-toolchain.cmake

cmake . \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR \
    -DCMAKE_CACHEFILE_DIR=$BASE_DIR/$MODULE/fbuild \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=TRUE \
    -DOSS_SUPPORT=FALSE \
    -Denable-ladspa=no \
    -Denable-portaudio=no \
    -Denable-debug=no \
    -Denable-libsndfile=no \
    -Denable-aufile=no \
    -Denable-pulseaudio=no \
    -Denable-jack=no \
    -Denable-midishare=no \
    -Denable-readline=no \
    -Denable-dbus=no \
    -Denable-ladcca=no \
    -Denable-lash=no \
    -Denable-alsa=no \
    -Denable-coreaudio=no \
    -Denable-coremidi=no \
    -Denable-framework=no \
    -Denable-dart=no \
    -G'MSYS Makefiles' \
    || exit 1

make || exit 1
make install || exit 1
make clean || exit 1

rm -rf config.h \
       fluidsynth.pc \
       CPackConfig.cmake \
       CPackSourceConfig.cmake \
       CMakeCache.txt \
       cmake_install.cmake \
       Makefile \
       CMakeFiles \
       install_manifest.txt \
       || exit 1

cmake . \
    -DCMAKE_INSTALL_PREFIX=$BUILD_DIR \
    -DCMAKE_CACHEFILE_DIR=$BASE_DIR/$MODULE/fbuild \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=FALSE \
    -DOSS_SUPPORT=FALSE \
    -Denable-ladspa=no \
    -Denable-portaudio=no \
    -Denable-debug=no \
    -Denable-libsndfile=no \
    -Denable-aufile=no \
    -Denable-pulseaudio=no \
    -Denable-jack=no \
    -Denable-midishare=no \
    -Denable-readline=no \
    -Denable-dbus=no \
    -Denable-ladcca=no \
    -Denable-lash=no \
    -Denable-alsa=no \
    -Denable-coreaudio=no \
    -Denable-coremidi=no \
    -Denable-framework=no \
    -Denable-dart=no \
    -G'MSYS Makefiles' \
    || exit 1

make && make install

