#!/usr/bin/env bash
ROOT=$1
NAME="tcl"
VER="8.6.10"
EXT="tar.gz"
DOC_URL="https://downloads.sourceforge.net/${NAME}/${NAME}${VER}-html.${EXT}"
URL="https://downloads.sourceforge.net/${NAME}/${NAME}${VER}-src.${EXT}"
if [[ ! -d "${ROOT}/temp" ]]
then
    exit 1
fi
if [[ -d "${ROOT}/temp/${NAME}" ]]
then
	rm -rf "${ROOT}/temp/${NAME}"
fi
mkdir "${ROOT}/temp/${NAME}"
TMP="${ROOT}/temp/${NAME}"
mkdir "${TMP}/sources"
mkdir "${TMP}/build"
ARCHIVE="${NAME}${VER}-src.${EXT}"
DOC_ARCHIVE="${NAME}${VER}-html.${EXT}"
wget "${URL}" -O "${TMP}/${ARCHIVE}" || exit 1
wget "${DOC_URL}" -O "${TMP}/${DOC_ARCHIVE}" || exit 1
tar -xf "${TMP}/${ARCHIVE}" -C "${TMP}/sources" || exit 1
SRC_DIR="${TMP}/sources/${NAME}${VER}"
cd ${SRC_DIR}
tar -xf "${TMP}/${DOC_ARCHIVE}" -C "${SRC_DIR}" || exit 1
mkdir -p "${TMP}/build/usr/share/man"
SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit)
make -j $(nproc)
sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.1|/usr/lib/tdbc1.1.1|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1|/usr/include|"            \
    -i pkgs/tdbc1.1.1/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.0|/usr/lib/itcl4.2.0|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.0/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.0|/usr/include|"            \
    -i pkgs/itcl4.2.0/itclConfig.sh

unset SRCDIR
make DESTDIR="${TMP}/build" install
chmod -v u+w ${TMP}/build/usr/lib/libtcl8.6.so
make DESTDIR="${TMP}/build" install-private-headers
ln -sv "${TMP}/build/usr/bin/tclsh8.6" "${TMP}/build/usr/bin/tclsh"
cd ${ROOT}
# Define .PKG vars
DATE=`date +"%D-%H:%M"`
PACKAGER=$USER
echo "name = \"${NAME}\"" | tee -a "${TMP}/build/.PKG"
echo "version = $VER" | tee -a "${TMP}/build/.PKG"
echo "subversion = 1" | tee -a "${TMP}/build/.PKG"
echo "architecture = \"x64\"" | tee -a "${TMP}/build/.PKG"
echo "packager = \"$USER\"" | tee -a "${TMP}/build/.PKG"
echo "url = \"${URL}\"" | tee -a "${TMP}/build/.PKG"
touch "${TMP}/build/.INSTALL"
cd "${TMP}/build"
tar -czf "${ROOT}/build/${NAME}-${VER}.tar.zst" .
cd "${ROOT}"
