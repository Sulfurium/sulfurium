#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="m4"
VER="1.4.18"
EXT="tar.xz"
URL="http://ftp.gnu.org/gnu/m4/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
./configure --prefix=/usr
make_and_install $TMP
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
