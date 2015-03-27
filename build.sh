#!/bin/bash

set -e

./build-zlib-1.2.8.sh
./build-bzip2-1.0.6.sh
./build-libiconv-1.14.sh
./build-xz-5.2.0.sh
./build-libxml2-2.9.2.sh
./build-expat-2.1.0.sh
./build-libxslt-1.1.28.sh
./build-libffi-3.2.1.sh
./build-pcre-8.35.sh
./build-gettext-0.19.4.sh
./build-glib-2.42.1.sh
./build-jpeg-9a.sh
./build-libpng-1.5.14.sh
./build-libtiff-4.0.3.sh
./build-libwebp-0.4.0.sh
./build-docbook.sh
./build-itstool-2.0.2.sh
./build-gtk-doc-1.21.sh
./build-ragel-6.9.sh
./build-freetype-2.5.5.sh
./build-harfbuzz.sh
./build-pixman-0.32.6.sh*
./build-cairo-1.14.2.sh
./build-pango-1.36.8.sh
./build-gobject-introspection-1.31.22.sh
./build-lua-5.3.2.sh
# LGI
./build-libogg-1.3.1.sh
./build-libvorbis-1.3.4.sh
./build-flac-1.3.0.sh
./build-libmad-0.15.1b.sh
./build-libmikmod-3.3.6.sh
./build-sdl-1.2.15.sh
./build-sdl_image-1.2.12.sh
./build-sdl_mixer-1.2.12.sh
./build-dumb-0.9.3.sh
# fluidsynth (cmake...)
# portmidi (cmake...)
# polarssl (cmake...)
./build-c-ares-1.10.0.sh
./build-curl-7.41.0.sh*
./build-json-c.sh
./build-libxdiff-0.23.sh
./build-enet-1.3.12.sh

