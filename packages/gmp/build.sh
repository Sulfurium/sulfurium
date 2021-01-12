#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="gmp"
VER="6.2.0"
EXT="tar.xz"
URL="http://ftp.gnu.org/gnu/gmp/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub # Don't optimize for host
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-${VER}
make $(get_make_args)
make html $(get_make_args)
make install DESTDIR="$TMP/build"
make install-html DESTDIR="${TMP}/build"
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
