#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="gcc"
VER="10.2.0"
EXT="tar.xz"
URL="http://ftp.gnu.org/gnu/gcc/gcc-${VER}/gcc-${VER}.tar.xz"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
mkdir -v build
cd       build
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib
make_and_install $TMP
rm -rf $TMP/build/usr/lib/gcc/$(gcc -dumpmachine)/${VER}/include-fixed/bits/
ln -sv ../usr/bin/cpp $TMP/build/lib
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/${VER}/liblto_plugin.so \
        $TMP/build/usr/lib/bfd-plugins/
mkdir -pv $TMP/build/usr/share/gdb/auto-load/usr/lib
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
