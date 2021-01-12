#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="attr"
VER="2.4.48"
EXT="tar.gz"
URL="http://download.savannah.gnu.org/releases/attr/${NAME}-${VER}.${EXT}"
if [[ ! -d "${ROOT}/temp" ]]
then
    exit 1
fi
if [[ -d "${ROOT}/temp/${NAME}" ]]
then
	rm -rf "${ROOT}/temp/${NAME}"
fi
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
ARCHIVE="${NAME}-${VER}.${EXT}"
wget "${URL}" -O "${TMP}/${ARCHIVE}" || exit 1
tar -xf "${TMP}/${ARCHIVE}" -C "${TMP}/sources" || exit 1
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-${VER}
make $(get_make_args)
make install DESTDIR="$TMP/build"
mkdir $TMP/build/lib
mv -v $TMP/build/usr/lib/libattr.so.* $TMP/build/lib
ln -sfv ../../lib/$(readlink $TMP/build/usr/lib/libattr.so) $TMP/build/usr/lib/libattr.so
cd ${ROOT}
# Define .PKG vars
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
cd "${ROOT}"
