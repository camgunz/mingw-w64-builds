#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

export XML_CATALOG_FILES="/etc/xml/catalog"

XMLCATALOG="/bin/xmlcatalog -v -v"

URL='http://downloads.sourceforge.net/docbook/docbook-xsl-1.78.1.tar.bz2'
ARCHIVE_NAME='docbook-xsl-1.78.1.tar.bz2'
TARBALL_NAME='docbook-xsl-1.78.1.tar'
SOURCE_DIR_NAME='docbook-xsl-1.78.1'

pushd ${ARCHIVE_DIR} > /dev/null
curl --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

bunzip2 ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

popd > /dev/null

mkdir -p "/etc/xml"

rm -f /etc/xml/catalog \
      /etc/xml/docbook \
      /etc/xml/docbook-xml \
      || exit 1

${XMLCATALOG} --noout --create "/etc/xml/docbook" || exit 1
${XMLCATALOG} --noout --create "/etc/xml/catalog" || exit 1
${XMLCATALOG} --noout --create "/etc/xml/docbook-xml" || exit 1
rm -f /docbook-xml.sav || exit 1
rm -f /docbook-xml.tmp || exit 1
rm -f /docbook-xml.tmp.2 || exit 1
rm -f /catalog.sav || exit 1
rm -f /catalog.tmp || exit 1
rm -f /catalog.tmp.2 || exit 1

pushd ${SOURCE_DIR} > /dev/null
for dtdversion in 4.1.2 4.2 4.3 4.4 4.5
do
    base_url="http://www.docbook.org/xml"
    source_dir_name="docbook-xml-${dtdversion}"
    dest_dir="/share/xml/docbook/xml-dtd-${dtdversion}"

    if [ $dtdversion == '4.1.2' ]
    then
        url="${base_url}/${dtdversion}/docbkx412.zip"
        archive_name="docbkx412.zip"
    else
        url="${base_url}/${dtdversion}/docbook-xml-${dtdversion}.zip"
        archive_name="docbook-xml-${dtdversion}.zip"
    fi

    pushd ${ARCHIVE_DIR} > /dev/null
    curl --retry 5 --remote-name -L ${url} || exit 1
    popd > /dev/null

    if [ -d ${source_dir_name} ]
    then
        rm -rf ${source_dir_name}
    fi

    mkdir "${SOURCE_DIR}/${source_dir_name}" || exit 1
    pushd "${SOURCE_DIR}/${source_dir_name}" > /dev/null
    unzip "${ARCHIVE_DIR}/${archive_name}" || exit 1
    rm -f "${ARCHIVE_DIR}/${archive_name}" || exit 1

    # if [ $dtdversion == '4.1.2' ]
    # then
    #     patch -p1 -f -i ${PATCH_DIR}/docbook-add-catalog-all.patch \
    #     || exit 1
    # elif [ $dtdversion == '4.2' ]
    # then
    #     patch -p1 -f -i ${PATCH_DIR}/docbook-add-system-all.patch \
    #     || exit 1
    # elif [ $dtdversion == '4.3' ]
    # then
    #     patch_name=${PATCH_DIR}/docbook-add-system-and-htmltbl-all.patch
    #     patch -p1 -f -i $patch_name \
    #     || exit 1
    # fi

    mkdir -p ${dest_dir} || exit 1
    cp -dRf docbook.cat *.dtd *.mod ent/ ${dest_dir}/ || exit 1
    popd > /dev/null
done

# V4.1.2
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1

${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/calstblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/calstblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/soextblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/dbpoolx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/dbhierx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/dbgenent.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook XML Notations V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/dbnotnx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.1.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.1.2/dbcentx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteSystem' \
    "http://www.oasis-open.org/docbook/xml/4.1.2" \
    "file:///share/xml/docbook/xml-dtd-4.1.2" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteURI' \
    "http://www.oasis-open.org/docbook/xml/4.1.2" \
    "file:///share/xml/docbook/xml-dtd-4.1.2" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1

# V4.2
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML V4.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook CALS Table Model V4.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/calstblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/soextblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook Information Pool V4.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/dbpoolx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook Document Hierarchy V4.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/dbhierx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Additional General Entities V4.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/dbgenent.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Notations V4.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/dbnotnx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Character Entities V4.2//EN" \
    "http://www.oasis-open.org/docbook/xml/4.2/dbcentx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteSystem' \
    "http://www.oasis-open.org/docbook/xml/4.2" \
    "file:///share/xml/docbook/xml-dtd-4.2" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteURI' \
    "http://www.oasis-open.org/docbook/xml/4.2" \
    "file:///share/xml/docbook/xml-dtd-4.2" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1

# V4.3
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML V4.3//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook CALS Table Model V4.3//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/calstblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/soextblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook Information Pool V4.3//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/dbpoolx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook Document Hierarchy V4.3//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/dbhierx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Additional General Entities V4.3//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/dbgenent.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Notations V4.3//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/dbnotnx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Character Entities V4.3//EN" \
    "http://www.oasis-open.org/docbook/xml/4.3/dbcentx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteSystem' \
    "http://www.oasis-open.org/docbook/xml/4.3" \
    "file:///share/xml/docbook/xml-dtd-4.3" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteURI' \
    "http://www.oasis-open.org/docbook/xml/4.3" \
    "file:///share/xml/docbook/xml-dtd-4.3" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1

# V4.4
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook CALS Table Model V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/calstblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/htmltblx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/soextblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook Information Pool V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/dbpoolx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook Document Hierarchy V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/dbhierx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Additional General Entities V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/dbgenent.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Notations V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/dbnotnx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook Character Entities V4.4//EN" \
    "http://www.oasis-open.org/docbook/xml/4.4/dbcentx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteSystem' \
    "http://www.oasis-open.org/docbook/xml/4.4" \
    "file:///share/xml/docbook/xml-dtd-4.4" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteURI' \
    "http://www.oasis-open.org/docbook/xml/4.4" \
    "file:///share/xml/docbook/xml-dtd-4.4" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1

# V4.5
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/calstblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/soextblx.dtd" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/dbpoolx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/dbhierx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/htmltblx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/dbnotnx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/dbcentx.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'public' \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
    "file:///share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteSystem' \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///share/xml/docbook/xml-dtd-4.5" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1
${XMLCATALOG} --add 'rewriteURI' \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///share/xml/docbook/xml-dtd-4.5" \
    "/etc/xml/docbook-xml" \
    | tail -n 2 | head -n 1 >> /docbook-xml.tmp \
    || exit 1

# if [ ! -e /etc/xml/catalog ]
# then
#     ${XMLCATALOG} --noout --create /etc/xml/catalog
# fi

${XMLCATALOG} --add 'delegatePublic' \
    '-//OASIS//ENTITIES DocBook XML' \
    "/etc/xml/docbook-xml" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1
${XMLCATALOG} --add 'delegatePublic' \
    '-//OASIS//DTD DocBook XML' \
    "/etc/xml/docbook-xml" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1
${XMLCATALOG} --add 'delegateSystem' \
    "http://www.oasis-open.org/docbook/" \
    "/etc/xml/docbook-xml" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1
${XMLCATALOG} --add 'delegateURI' \
    "http://www.oasis-open.org/docbook/" \
    "/etc/xml/docbook-xml" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1

pushd ${SOURCE_DIR} > /dev/null
pushd ${SOURCE_DIR_NAME} > /dev/null
echo `pwd`

install -dm755 /share/xml/docbook/xsl-stylesheets-1.78.1
install -m644 VERSION VERSION.xsl /share/xml/docbook/xsl-stylesheets-1.78.1

for x in assembly common eclipse epub epub3 fo highlighting html htmlhelp javahelp lib \
         manpages params profiling roundtrip template website xhtml xhtml-1_1 xhtml5
do
    install -dm755 /share/xml/docbook/xsl-stylesheets-1.78.1/${x}
    install -m644 ${x}/*.{xml,xsl,dtd,ent} /share/xml/docbook/xsl-stylesheets-1.78.1/${x} || true  # ignore missing files
done

install -dm755 /etc/xml
install -Dm644 COPYING /usr/share/licenses/docbook-xsl/LICENSE

popd > /dev/null
popd > /dev/null

xmlcatalog --add "rewriteSystem" \
    "http://docbook.sourceforge.net/release/xsl/1.78.1" \
    "/share/xml/docbook/xsl-stylesheets-1.78.1" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1

xmlcatalog --add "rewriteURI" \
    "http://docbook.sourceforge.net/release/xsl/1.78.1" \
    "/share/xml/docbook/xsl-stylesheets-1.78.1" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1

xmlcatalog --add "rewriteSystem" \
    "http://docbook.sourceforge.net/release/xsl/current" \
    "/share/xml/docbook/xsl-stylesheets-1.78.1" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1

xmlcatalog --add "rewriteURI" \
    "http://docbook.sourceforge.net/release/xsl/current" \
    "/share/xml/docbook/xsl-stylesheets-1.78.1" \
    "/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> /catalog.tmp \
    || exit 1

echo '</catalog>' >> /docbook-xml.tmp
sed -i 's|:catalog"/>|:catalog">|g' /etc/xml/docbook-xml
cat /etc/xml/docbook-xml > /docbook-xml.tmp.2
cp /etc/xml/docbook-xml /docbook-xml.sav
rm -f /etc/xml/docbook-xml
cat /docbook-xml.tmp >> /docbook-xml.tmp.2
# rm -f /docbook-xml.tmp
mv /docbook-xml.tmp.2 /etc/xml/docbook-xml
# rm -f /docbook-xml.tmp.2

echo '</catalog>' >> /catalog.tmp
sed -i 's|:catalog"/>|:catalog">|g' /etc/xml/catalog
cat /etc/xml/catalog > /catalog.tmp.2
cp /etc/xml/catalog /catalog.sav
rm -f /etc/xml/catalog
cat /catalog.tmp >> /catalog.tmp.2
# rm -f /catalog.tmp
mv /catalog.tmp.2 /etc/xml/catalog
# rm -f /catalog.tmp.2 /etc/xml/catalog

