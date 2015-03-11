#!/bin/bash

set -e

# ./build-zlib-1.2.8.sh
# ./build-bzip2-1.0.6.sh
# ./build-libiconv-1.14.sh
# ./build-xz-5.2.0.sh
# ./build-libxml2-2.9.2.sh
# ./build-expat-2.1.0.sh
# ./build-libxslt-1.1.28.sh
# ./build-libffi-3.2.1.sh
# ./build-pcre-8.35.sh
# ./build-gettext-0.19.4.sh
# ./build-glib-2.42.1.sh
# ./build-jpeg-9a.sh
# ./build-libpng-1.5.14.sh
./build-docbook.sh
./build-gtk-doc-1.21.sh
./build-ragel-6.9.sh
./build-freetype-2.5.5.sh
./build-harfbuzz.sh

# pixman
# cairo
# pango

./build-gobject-introspection-1.31.22.sh
./build-lua-5.3.2.sh

# polarssl (cmake...)
# c-ares
# curl
# libxdiff
# enet

# dumb
# fluidsynth (cmake...)
# portmidi (cmake...)

# sdl

# tiff
# libwebp
# sdl_image

# libogg
# libvorbis
# flac
# libmad
# mikmod
# sdl_mixer

