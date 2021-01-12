#!/usr/bin/env bash
ROOT=$1
# Load build lib
source "${ROOT}/libpkgs.sh"
NAME="acl"
VER="2.2.53"
EXT="tar.gz"
URL="http://download.savannah.gnu.org/releases/${NAME}/${NAME}-${VER}.${EXT}"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
ARCHIVE="${NAME}-${VER}.${EXT}"
wget "${URL}" -O "${TMP}/${ARCHIVE}" || exit 1
tar -xf "${TMP}/${ARCHIVE}" -C "${TMP}/sources" || exit 1
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr         \
            --bindir=/bin         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/${NAME}-${VER}
make $(get_make_args)
make install DESTDIR="$TMP/build"
mkdir $TMP/build/lib
mv -v $TMP/build/usr/lib/libacl.so.* $TMP/build/lib
ln -sfv ../../lib/$(readlink $TMP/build/usr/lib/libacl.so) $TMP/build/usr/lib/libacl.so
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
cd "${ROOT}"
