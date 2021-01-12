#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="dejagnu"
VER="1.6.2"
EXT="tar.gz"
URL="http://ftp.gnu.org/gnu/${NAME}/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi
make install DESTDIR="${TMP}/build"
install -v -dm755  ${TMP}/build/usr/share/doc/dejagnu-${VER}
install -v -m644   doc/dejagnu.{html,txt} ${TMP}/build/usr/share/doc/dejagnu-${VER}
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
