#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="flex"
VER="2.6.4"
EXT="tar.gz"
URL="https://github.com/westes/flex/releases/download/v${VER}/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr --docdir=/usr/share/doc/flex-$VER
make_and_install $TMP
ln -sv flex $TMP/build/usr/bin/lex
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
