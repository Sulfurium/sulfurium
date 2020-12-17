#!/usr/bin/env bash
ROOT=$1
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
mkdir "${ROOT}/temp/${NAME}"
TMP="${ROOT}/temp/${NAME}"
mkdir "${TMP}/sources"
mkdir "${TMP}/build"
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
make -j $(nproc)
make install DESTDIR="$TMP/build"
mkdir $TMP/build/lib
mv -v $TMP/build/usr/lib/libattr.so.* $TMP/build/lib
ln -sfv ../../lib/$(readlink $TMP/build/usr/lib/libattr.so) $TMP/build/usr/lib/libattr.so
cd ${ROOT}
# Define .PKG vars
DATE=`date +"%D-%H:%M"`
PACKAGER=$USER
echo "name = \"${NAME}\"" | tee -a "${TMP}/build/.PKG"
echo "version = $VER" | tee -a "${TMP}/build/.PKG"
echo "subversion = 1" | tee -a "${TMP}/build/.PKG"
echo "architecture = \"x64\"" | tee -a "${TMP}/build/.PKG"
echo "packager = \"$USER\"" | tee -a "${TMP}/build/.PKG"
echo "url = \"${URL}\"" | tee -a "${TMP}/build/.PKG"
touch "${TMP}/build/.INSTALL"
cd "${TMP}/build"
tar -czf "${ROOT}/build/${NAME}-${VER}.tar.zst" .
cd "${ROOT}"
