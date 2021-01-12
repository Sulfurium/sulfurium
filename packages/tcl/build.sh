#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="tcl"
VER="8.6.10"
EXT="tar.gz"
DOC_URL="https://downloads.sourceforge.net/${NAME}/${NAME}${VER}-html.${EXT}"
URL="https://downloads.sourceforge.net/${NAME}/${NAME}${VER}-src.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
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
make $(get_make_opts)
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
ln -sv "tclsh8.6" "${TMP}/build/usr/bin/tclsh"
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT

