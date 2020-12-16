#!/usr/bin/env bash
ROOT=$1
NAME="glibc"
VER="2.32"
EXT="tar.xz"
URL="http://ftp.gnu.org/gnu/${NAME}/${NAME}-${VER}.tar.xz"
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
wget "http://www.linuxfromscratch.org/patches/lfs/10.0/${NAME}-${VER}-fhs-1.patch" -O "${TMP}/${NAME}.patch" || exit 1
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
make -j $(nproc) || exit 1
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
