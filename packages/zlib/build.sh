#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="zlib"
VER="1.2.11"
EXT="tar.xz"
URL="https://zlib.net/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr
make_and_install $TMP
mkdir $TMP/build/lib
mv -v $TMP/build/usr/lib/libz.so.* $TMP/build/lib/
ln -sfv $TMP/build/lib/$(readlink $TMP/build/usr/lib/libz.so) $TMP/build/usr/lib/libz.s
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
