#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL='https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz'
ARCHIVE_NAME='SDL_mixer-1.2.12.tar.gz'
TARBALL_NAME='SDL_mixer-1.2.12.tar'
SOURCE_DIR_NAME='SDL_mixer-1.2.12'

pushd ${ARCHIVE_DIR} > /dev/null
curl --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

gunzip ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar f ${ARCHIVE_DIR}/${TARBALL_NAME} --wildcards --delete 'Xcode/*'
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME}
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

# --enable-music-fluidsynth-shared \

mv ${BUILD_DIR}/lib/libSDLmain.la ${BUILD_DIR}/lib/libSDLmain.la.bak

./configure --disable-static \
            --enable-shared \
            --with-sdl-prefix=${BUILD_DIR} \
            --disable-sdltest \
            --disable-smpegtest \
            --disable-music-mp3 \
            --disable-music-mod-modplug \
            --enable-music-mp3-mad-gpl \
            --enable-music-mod \
            --enable-music-mod-shared \
            --enable-music-ogg-shared \
            --enable-music-flac-shared \
            --enable-music-mp3-shared \
            || exit 1
make -j 1
make DESTDIR=${BUILD_DIR} install

popd > /dev/null
popd > /dev/null

