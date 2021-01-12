#!/usr/bin/env bash
ROOT=$1
source "${ROOT}/libpkgs.sh"
NAME="glibc"
VER="2.32"
EXT="tar.xz"
URL="http://ftp.gnu.org/gnu/${NAME}/${NAME}-${VER}.tar.xz"
TMP="${ROOT}/temp/${NAME}"
config_pkg_dirs $NAME $ROOT
download_and_unpack $URL $TMP $NAME $VER $EXT 
cp ${ROOT}/packages/${NAME}/${NAME}-fhs.patch $TMP/${NAME}.patch
SRC_DIR="${TMP}/sources/${NAME}-${VER}"
cd ${SRC_DIR}
patch -Np1 -i ${TMP}/${NAME}.patch
mkdir -v build
cd build
mkdir -p "${TMP}/build/lib"
mkdir -p "${TMP}/build/usr/include"
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/build/lib
make $(get_make_args) || exit 1
ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 ${TMP}/build/lib/
touch $TMP/build/etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install DESTDIR="${TMP}/build/"
cp -v ../nscd/nscd.conf ${TMP}/build/etc/nscd.conf
mkdir  ${TMP}/build/var/cache/nscd/
mkdir  ${TMP}/build/usr/lib/locale
make localedata/install-locales DESTDIR="${TMP}/build/"
cat > ${TMP}/build/etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
wget "https://www.iana.org/time-zones/repository/releases/tzdata2020a.tar.gz" -O "${TMP}/tzdata.tar.gz"
tar -xf "${TMP}/tzdata.tar.gz"
ZONEINFO=${TMP}/build/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
cat > ${TMP}/build/etc/ld.so.conf << "EOF"
# Début de /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
construct_PKG_file $NAME $VER $URL $TMP
pack_zst "${TMP}/build" $NAME $VER $ROOT
