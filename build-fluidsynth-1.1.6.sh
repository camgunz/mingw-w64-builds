#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL="http://downloads.sourceforge.net/project/fluidsynth/fluidsynth-1.1.6/fluidsynth-1.1.6.tar.bz2"
ARCHIVE_NAME="fluidsynth-1.1.6.tar.bz2"
TARBALL_NAME="fluidsynth-1.1.6.tar"
SOURCE_DIR_NAME="fluidsynth-1.1.6"

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

CFLAGS="$CFLAGS -DFLUIDSYNTH_NOT_A_DLL" \
cmake . -DCMAKE_INSTALL_PREFIX=$PREFIX \
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
        || exit 1

make && make install && make clean || exit 1

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

cmake . -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DCMAKE_CACHEFILE_DIR=$BASE_DIR/$MODULE/fbuild \
        -DCMAKE_BUILD_TYPE=Release \
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
        || exit 1

make && make install

popd > /dev/null
popd > /dev/null

