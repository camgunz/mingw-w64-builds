#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

XMLCATALOG="${BUILD_DIR}/bin/xmlcatalog -v -v"

rm -f /etc/xml/catalog /etc/xml/docbook || exit 1

${XMLCATALOG} --noout --create /etc/xml/catalog || exit 1

${XMLCATALOG} --noout --create /etc/xml/docbook || exit 1

pushd ${SOURCE_DIR} > /dev/null
for dtdversion in 4.1.2 4.2 4.3 4.4 4.5
do
    base_url="http://www.docbook.org/xml"
    source_dir_name="docbook-xml-${dtdversion}"
    dest_dir=${BUILD_DIR}/share/xml/docbook/xml-dtd-${dtdversion}

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

    mkdir ${SOURCE_DIR}/${source_dir_name} || exit 1
    pushd ${SOURCE_DIR}/${source_dir_name} > /dev/null
    unzip ${ARCHIVE_DIR}/${archive_name} || exit 1
    rm -f ${ARCHIVE_DIR}/${archive_name} || exit 1

    if [ $dtdversion == '4.1.2' ]
    then
        patch -p1 -f -i ${PATCH_DIR}/docbook-add-catalog-all.patch || exit 1
    elif [ $dtdversion == '4.2' ]
    then
        patch -p1 -f -i ${PATCH_DIR}/docbook-add-system-all.patch || exit 1
    elif [ $dtdversion == '4.3' ]
    then
        patch -p1 -f -i ${PATCH_DIR}/docbook-add-system-and-htmltbl-all.patch \
        || exit 1
    fi

    mkdir -p ${dest_dir} || exit 1
    cp -dRf docbook.cat *.dtd *.mod ent/ ${dest_dir}/ || exit 1
    popd > /dev/null

    echo 'First one'
    ${XMLCATALOG} --noout \
        --add 'nextCatalog' '' "file:///share/docbook/xml/${dtdversion}/catalog.xml" \
        || exit 1

    echo 'Second one'
    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//DTD DocBook XML V${dtdversion}//EN" \
        "http://www.oasis-open.org/docbook/xml/${dtdversion}/docbookx.dtd" \
        || exit 1

    exit 0

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//DTD DocBook XML CALS Table Model V${dtdversion}//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/calstblx.dtd" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/soextblx.dtd" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//ELEMENTS DocBook XML Information Pool V${dtdversion}//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/dbpoolx.mod" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V${dtdversion}//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/dbhierx.mod" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//ELEMENTS DocBook XML HTML Tables V${dtdversion}//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/htmltblx.mod" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//ENTITIES DocBook XML Notations V${dtdversion}//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/dbnotnx.mod" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//ENTITIES DocBook XML Character Entities V${dtdversion}//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/dbcentx.mod" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "public" \
        "-//OASIS//ENTITIES DocBook XML Additional General Entities V${dtdversion}//EN" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}/dbgenent.mod" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "rewriteSystem" \
        "http://www.oasis-open.org/docbook/xml/${dtdversion}" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}" \
        /etc/xml/docbook || exit 1

    ${XMLCATALOG} --noout --add "rewriteURI" \
        "http://www.oasis-open.org/docbook/xml/${dtdversion}" \
        "file:///share/xml/docbook/xml-dtd-${dtdversion}" \
        /etc/xml/docbook || exit 1
     ${XMLCATALOG} --noout --add "public" \
       "-//OASIS//DTD DocBook XML V$dtdversion//EN" \
       "http://www.oasis-open.org/docbook/xml/$dtdversion/docbookx.dtd" \
       /etc/xml/docbook || exit 1
     ${XMLCATALOG} --noout --add "rewriteSystem" \
       "http://www.oasis-open.org/docbook/xml/$dtdversion" \
       "file:///share/xml/docbook/xml-dtd-4.5" \
       /etc/xml/docbook || exit 1
     ${XMLCATALOG} --noout --add "rewriteURI" \
       "http://www.oasis-open.org/docbook/xml/$dtdversion" \
       "file:///share/xml/docbook/xml-dtd-4.5" \
       /etc/xml/docbook || exit 1
     ${XMLCATALOG} --noout --add "delegateSystem" \
       "http://www.oasis-open.org/docbook/xml/$dtdversion/" \
       "file:///etc/xml/docbook" \
       /etc/xml/catalog || exit 1
     ${XMLCATALOG} --noout --add "delegateURI" \
       "http://www.oasis-open.org/docbook/xml/$dtdversion/" \
       "file:///etc/xml/docbook" \
       /etc/xml/catalog || exit 1
done
popd > /dev/null

${XMLCATALOG} --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog || exit 1
${XMLCATALOG} --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog || exit 1
${XMLCATALOG} --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog || exit 1
${XMLCATALOG} --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog || exit 1

mkdir -p /share/docbook/xsl || exit 1
pushd /share/docbook/xsl > /dev/null
# curl --retry 5 --remote-name -L http://downloads.sourceforge.net/project/docbook/docbook-xsl/1.78.1/docbook-xsl-1.78.1.tar.bz2 || exit 1
curl --retry 5 --remote-name -L http://ufpr.dl.sourceforge.net/project/docbook/docbook-xsl/1.78.1/docbook-xsl-1.78.1.tar.bz2 || exit 1
bunzip2 docbook-xsl-1.78.1.tar.bz2 || exit 1
tar xf docbook-xsl-1.78.1.tar || exit 1
rm -f docbook-xsl-1.78.1.tar docbook-xsl-1.78.1.tar.bz2 || exit 1
${XMLCATALOG} --noout \
    --add 'nextCatalog' '' 'file:///share/docbook/xsl/1.78.1/catalog.xml' \
    --create /etc/xml/catalog
popd > /dev/null

