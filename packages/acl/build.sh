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
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
./configure --prefix=/usr         \
            --bindir=/bin         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/${NAME}-${VER}
make_and_install $TMP
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
