#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="mpfr"
VER="4.1.0"
EXT="tar.xz"
URL="http://ftp.gnu.org/gnu/mpfr/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr    \
            --enable-thread-safe     \
            --disable-static \
            --docdir=/usr/share/doc/${NAME}-${VER}
make $(get_make_args)
make html $(get_make_args)
make install DESTDIR="$TMP/build"
make install-html DESTDIR="${TMP}/build"
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
