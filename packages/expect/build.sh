#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="expect"
VER="5.45.4"
EXT="tar.gz"
URL="https://prdownloads.sourceforge.net/${NAME}/${NAME}${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr           \
            --with-tcl=${ROOT}/temp/tcl/build/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=${ROOT}/temp/tcl/build/usr/include
make_and_install $TMP
ln -svf libexpect5.45.4.so ${TMP}/build/usr/lib
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT