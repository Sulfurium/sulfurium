#!/usr/bin/env bash
ROOT=$1
NAME="libcap"
VER="2.42"
EXT="tar.xz"
URL="https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${NAME}-${VER}.${EXT}"
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
mkdir $TMP/build/lib
sed -i '/install -m.*STACAPLIBNAME/d' libcap/Makefile
make lib=lib

make lib=lib PKGCONFIGDIR=/usr/lib/pkgconfig DESTDIR=$TMP/build/ install
chmod -v 755 $TMP/build/lib/libcap.so.2.42
mv -v $TMP/build/lib/libpsx.a $TMP/build/usr/lib
rm -v $TMP/build/lib/libcap.so
ln -sfv ../../lib/libcap.so.2 $TMP/build/usr/lib/libcap.so
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
