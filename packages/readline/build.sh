#!/usr/bin/env bash
ROOT=$1
NAME="readline"
VER="8.0"
EXT="tar.gz"
URL="http://ftp.gnu.org/gnu/readline/${NAME}-${VER}.${EXT}"
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
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.0
make SHLIB_LIBS="-lncursesw" -j $(nproc)
make SHLIB_LIBS="-lncursesw" DESTDIR="$TMP/build" install
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
