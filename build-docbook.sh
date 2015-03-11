#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

export XML_CATALOG_FILES="${BUILD_DIR}/etc/xml/catalog"

XMLCATALOG="${BUILD_DIR}/bin/xmlcatalog -v -v"

mkdir -p "${BUILD_DIR}/etc/xml"

rm -f ${BUILD_DIR}/etc/xml/catalog \
      ${BUILD_DIR}/etc/xml/docbook \
      ${BUILD_DIR}/etc/xml/docbook-xml \
      || exit 1

${XMLCATALOG} --noout --create "${BUILD_DIR}/etc/xml/docbook" || exit 1
${XMLCATALOG} --noout --create "${BUILD_DIR}/etc/xml/catalog" || exit 1
${XMLCATALOG} --noout --create "${BUILD_DIR}/etc/xml/docbook-xml" || exit 1
rm -f ${BUILD_DIR}/docbook-xml.sav || exit 1
rm -f ${BUILD_DIR}/docbook-xml.tmp || exit 1
rm -f ${BUILD_DIR}/docbook-xml.tmp.2 || exit 1
rm -f ${BUILD_DIR}/catalog.sav || exit 1
rm -f ${BUILD_DIR}/catalog.tmp || exit 1
rm -f ${BUILD_DIR}/catalog.tmp.2 || exit 1

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
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook XML CALS Table Model V4.1.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/calstblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook XML CALS Table Model V4.1.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/calstblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/soextblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook XML Information Pool V4.1.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/dbpoolx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.1.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/dbhierx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.1.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/dbgenent.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook XML Notations V4.1.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/dbnotnx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook XML Character Entities V4.1.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.1.2/dbcentx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteSystem' \
  "http://www.oasis-open.org/docbook/xml/4.1.2" \
  "file:///share/xml/docbook/xml-dtd-4.1.2" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteURI' \
  "http://www.oasis-open.org/docbook/xml/4.1.2" \
  "file:///share/xml/docbook/xml-dtd-4.1.2" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp

# V4.2
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook XML V4.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook CALS Table Model V4.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/calstblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/soextblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook Information Pool V4.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/dbpoolx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook Document Hierarchy V4.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/dbhierx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Additional General Entities V4.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/dbgenent.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Notations V4.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/dbnotnx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Character Entities V4.2//EN" \
  "http://www.oasis-open.org/docbook/xml/4.2/dbcentx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteSystem' \
  "http://www.oasis-open.org/docbook/xml/4.2" \
  "file:///share/xml/docbook/xml-dtd-4.2" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteURI' \
  "http://www.oasis-open.org/docbook/xml/4.2" \
  "file:///share/xml/docbook/xml-dtd-4.2" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp

# V4.3
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook XML V4.3//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook CALS Table Model V4.3//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/calstblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/soextblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook Information Pool V4.3//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/dbpoolx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook Document Hierarchy V4.3//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/dbhierx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Additional General Entities V4.3//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/dbgenent.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Notations V4.3//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/dbnotnx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Character Entities V4.3//EN" \
  "http://www.oasis-open.org/docbook/xml/4.3/dbcentx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteSystem' \
  "http://www.oasis-open.org/docbook/xml/4.3" \
  "file:///share/xml/docbook/xml-dtd-4.3" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteURI' \
  "http://www.oasis-open.org/docbook/xml/4.3" \
  "file:///share/xml/docbook/xml-dtd-4.3" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp

# V4.4
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook XML V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook CALS Table Model V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/calstblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/htmltblx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/soextblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook Information Pool V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/dbpoolx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook Document Hierarchy V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/dbhierx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Additional General Entities V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/dbgenent.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Notations V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/dbnotnx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook Character Entities V4.4//EN" \
  "http://www.oasis-open.org/docbook/xml/4.4/dbcentx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteSystem' \
  "http://www.oasis-open.org/docbook/xml/4.4" \
  "file:///share/xml/docbook/xml-dtd-4.4" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteURI' \
  "http://www.oasis-open.org/docbook/xml/4.4" \
  "file:///share/xml/docbook/xml-dtd-4.4" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp

# V4.5
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook XML V4.5//EN" \
  "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/calstblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/soextblx.dtd" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/dbpoolx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/dbhierx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/htmltblx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/dbnotnx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/dbcentx.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'public' \
  "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
  "file:///share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteSystem' \
  "http://www.oasis-open.org/docbook/xml/4.5" \
  "file:///share/xml/docbook/xml-dtd-4.5" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp
${XMLCATALOG} --add 'rewriteURI' \
  "http://www.oasis-open.org/docbook/xml/4.5" \
  "file:///share/xml/docbook/xml-dtd-4.5" \
  "${BUILD_DIR}/etc/xml/docbook-xml" \
  | tail -n 2 | head -n 1 >> ${BUILD_DIR}/docbook-xml.tmp

# if [ ! -e ${BUILD_DIR}/etc/xml/catalog ]
# then
#     ${XMLCATALOG} --noout --create ${BUILD_DIR}/etc/xml/catalog
# fi

${XMLCATALOG} --add 'delegatePublic' \
    '-//OASIS//ENTITIES DocBook XML' \
    "${BUILD_DIR}/etc/xml/docbook-xml" \
    "${BUILD_DIR}/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> ${BUILD_DIR}/catalog.tmp
${XMLCATALOG} --add 'delegatePublic' \
    '-//OASIS//DTD DocBook XML' \
    "${BUILD_DIR}/etc/xml/docbook-xml" \
    "${BUILD_DIR}/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> ${BUILD_DIR}/catalog.tmp
${XMLCATALOG} --add 'delegateSystem' \
    "http://www.oasis-open.org/docbook/" \
    "${BUILD_DIR}/etc/xml/docbook-xml" \
    "${BUILD_DIR}/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> ${BUILD_DIR}/catalog.tmp
${XMLCATALOG} --add 'delegateURI' \
    "http://www.oasis-open.org/docbook/" \
    "${BUILD_DIR}/etc/xml/docbook-xml" \
    "${BUILD_DIR}/etc/xml/catalog" \
    | tail -n 2 | head -n 1 >> ${BUILD_DIR}/catalog.tmp

echo '</catalog>' >> ${BUILD_DIR}/docbook-xml.tmp
sed -i 's|:catalog"/>|:catalog">|g' ${BUILD_DIR}/etc/xml/docbook-xml
cat ${BUILD_DIR}/etc/xml/docbook-xml > ${BUILD_DIR}/docbook-xml.tmp.2
cp ${BUILD_DIR}/etc/xml/docbook-xml ${BUILD_DIR}/docbook-xml.sav
rm -f ${BUILD_DIR}/etc/xml/docbook-xml
cat ${BUILD_DIR}/docbook-xml.tmp >> ${BUILD_DIR}/docbook-xml.tmp.2
# rm -f ${BUILD_DIR}/docbook-xml.tmp
mv ${BUILD_DIR}/docbook-xml.tmp.2 ${BUILD_DIR}/etc/xml/docbook-xml
# rm -f ${BUILD_DIR}/docbook-xml.tmp.2

echo '</catalog>' >> ${BUILD_DIR}/catalog.tmp
sed -i 's|:catalog"/>|:catalog">|g' ${BUILD_DIR}/etc/xml/catalog
cat ${BUILD_DIR}/etc/xml/catalog > ${BUILD_DIR}/catalog.tmp.2
cp ${BUILD_DIR}/etc/xml/catalog ${BUILD_DIR}/catalog.sav
rm -f ${BUILD_DIR}/etc/xml/catalog
cat ${BUILD_DIR}/catalog.tmp >> ${BUILD_DIR}/catalog.tmp.2
# rm -f ${BUILD_DIR}/catalog.tmp
mv ${BUILD_DIR}/catalog.tmp.2 ${BUILD_DIR}/etc/xml/catalog
# rm -f ${BUILD_DIR}/catalog.tmp.2 ${BUILD_DIR}/etc/xml/catalog

