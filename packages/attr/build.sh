#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="attr"
VER="2.4.48"
EXT="tar.gz"
URL="http://download.savannah.gnu.org/releases/attr/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
ARCHIVE="${NAME}-${VER}.${EXT}"
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-${VER}
make_and_install $TMP
mkdir $TMP/build/lib
mv -v $TMP/build/usr/lib/libattr.so.* $TMP/build/lib
ln -sfv ../../lib/$(readlink $TMP/build/usr/lib/libattr.so) $TMP/build/usr/lib/libattr.so
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
cd "${ROOT}"
