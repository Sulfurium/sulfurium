#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="libcap"
VER="2.42"
EXT="tar.xz"
URL="https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
mkdir $TMP/build/lib
sed -i '/install -m.*STACAPLIBNAME/d' libcap/Makefile
make lib=lib

make lib=lib PKGCONFIGDIR=/usr/lib/pkgconfig DESTDIR=$TMP/build/ install
chmod -v 755 $TMP/build/lib/libcap.so.2.42
mv -v $TMP/build/lib/libpsx.a $TMP/build/usr/lib
rm -v $TMP/build/lib/libcap.so
ln -sfv ../../lib/libcap.so.2 $TMP/build/usr/lib/libcap.so
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
