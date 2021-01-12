#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="readline"
VER="8.0"
EXT="tar.gz"
URL="http://ftp.gnu.org/gnu/readline/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.0
make SHLIB_LIBS="-lncursesw" $(get_make_args)
make SHLIB_LIBS="-lncursesw" DESTDIR="$TMP/build" install
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
