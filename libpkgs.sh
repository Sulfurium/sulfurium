# Lib used for packages building
#$1: NAME
#$2: ROOT
config_pkg_dirs() {
    ROOT=$2
    NAME=$1
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
}
get_make_args() {
    echo "-j$(($(nproc) + 1))"
}
#$1: NAME
#$2: VERSION
#$3: URL
#$4: TMP
construct_PKG_file() {
    NAME=$1
    VER=$2
    URL=$3
    TMP=$4
    echo "name = \"${NAME}\"" | tee -a "${TMP}/build/.PKG"
    echo "version = $VER" | tee -a "${TMP}/build/.PKG"
    echo "subversion = 1" | tee -a "${TMP}/build/.PKG"
    echo "architecture = \"x64\"" | tee -a "${TMP}/build/.PKG"
    echo "packager = \"$USER\"" | tee -a "${TMP}/build/.PKG"
    echo "url = \"${URL}\"" | tee -a "${TMP}/build/.PKG"
    touch "${TMP}/build/.INSTALL"
}
# $1: Build dir
# $2: NAME
# $3: VER
# $4: ROOT
pack_zst() {
    cd $1
    BUILD=$1
    NAME=$2
    VER=$3
    ROOT=$4
    if [[ -d $BUILD/usr/lib ]]
    then
        find $BUILD/usr/lib -type f -name \*.a \
        -exec strip --strip-debug {} ';'
        find $BUILD/usr/lib -type f -name \*.so* \
        -exec strip --strip-unneeded {} ';'
    fi
    if [[ -d $BUILD/lib ]]
    then
        find $BUILD/lib -type f -name \*.so* \
        -exec strip --strip-unneeded {} ';'
    fi
    if [[ -d $BUILD/bin ]]
    then
        find $BUILD/bin -type f \
    -exec strip --strip-all {} ';'
    fi
    if [[ -d $BUILD/sbin ]]
    then
        find $BUILD/sbin -type f \
        -exec strip --strip-all {} ';'
    fi
    if [[ -d $BUILD/usr/sbin ]]
    then
        find $BUILD/usr/sbin -type f \
        -exec strip --strip-all {} ';'
    fi
    if [[ -d $BUILD/usr/bin ]]
    then
        find $BUILD/usr/bin -type f \
        -exec strip --strip-all {} ';'
    fi
    if [[ -d $BUILD/usr/libexec ]]
    then
        find $BUILD/usr/libexec -type f \
        -exec strip --strip-all {} ';'
    fi
    tar -czf "${ROOT}/build/${NAME}-${VER}.tar.zst" .

}