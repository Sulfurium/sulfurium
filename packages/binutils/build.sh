#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="binutils"
VER="2.35"
EXT="tar.xz"
URL="http://ftp.gnu.org/gnu/binutils/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in
mkdir build
cd build
mkdir $TMP/build/usr
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

make tooldir=/usr $(get_make_args)
make tooldir=/usr install DESTDIR="$TMP/build"
# Define .PKG vars
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
