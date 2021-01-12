#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="iana-etc"
VER="20200821"
EXT="tar.gz"
URL="https://github.com/Mic92/${NAME}/releases/download/${VER}/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
mkdir -p "${TMP}/build/etc"
cp services "${TMP}/build/etc/"
cp protocols "${TMP}/build/etc/"
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT

