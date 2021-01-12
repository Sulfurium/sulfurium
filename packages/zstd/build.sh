#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="zstd"
VER="1.4.5"
EXT="tar.gz"
URL="https://github.com/facebook/zstd/releases/download/v${VER}/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
make $(get_make_args)
mkdir -p $TMP/build/usr
make prefix=/usr DESTDIR=$TMP/build/ install
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
