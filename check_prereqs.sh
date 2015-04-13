#!/bin/bash

if [ ! "`which ${CURL}`" ]
then
    echo "Couldn't find curl program, install curl"
    exit 1
fi

if [ ! "`which unzip`" ]
then
    echo "Couldn't find unzip program, install unzip"
    exit 1
fi

if [ ! "`which hg`" ]
then
    echo "Couldn't find hg program, install Mercurial"
    exit 1
fi

if [ ! "`which ${GIT}`" ]
then
    echo "Couldn't find git program, install Git"
    exit 1
fi

if [ ! "`which svn`" ]
then
    echo "Couldn't find svn program, install Subversion"
    exit 1
fi

# if [ ! "`which msgfmt`" ]
# then
#     echo "Couldn't find msgfmt program, install gettext"
#     exit 1
# fi

if [ ! "`which libtool`" ]
then
    echo "Couldn't find libtool program, install libtool"
    exit 1
fi

# if [ ! "`which pkg-config`" ]
# then
#     echo "Couldn't find pkg-config program, install pkg-config"
#     exit 1
# fi

if [ ! "`which patch`" ]
then
    echo "Couldn't find patch program, install patch"
    exit 1
fi

# if [ ! "`which ragel`" ]
# then
#     echo "Couldn't find ragel program, install ragel"
#     exit 1
# fi

# if [ ! "`which doxygen`" ]
# then
#     echo "Couldn't find doxygen program, install Doxygen"
#     exit 1
# fi

# if [ ! "`which gtkdocize`" ]
# then
#     echo "Couldn't find gtkdocize program, install gtkdocize"
#     exit 1
# fi

if [ ! "`which bsdtar`" ]
then
    echo "Couldn't find bsdtar program, install tar (or libarchive)"
    exit 1
fi

if [ ! "`which xz`" ]
then
    echo "Couldn't find xz program, install xz"
    exit 1
fi

# if [ ! "`which lua5.1`" ]
# then
#     echo "Couldn't find lua5.1 program, install Lua 5.1"
#     exit 1
# fi

# if [ ! -f archives.list ]
# then
#     ./build_lists.py || exit 1
# fi

