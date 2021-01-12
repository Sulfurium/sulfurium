#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="bc"
VER="3.1.5"
EXT="tar.xz"
URL="https://github.com/gavinhoward/bc/releases/download/${VER}/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
ARCHIVE="${NAME}-${VER}.${EXT}"
wget "${URL}" -O "${TMP}/${ARCHIVE}" || exit 1
tar -xf "${TMP}/${ARCHIVE}" -C "${TMP}/sources" || exit 1
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3
make $(get_make_args)
make install DESTDIR="${TMP}/build"
cd ${ROOT}
# Define .PKG vars
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
cd $ROOT