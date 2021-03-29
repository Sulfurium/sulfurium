#!/usr/bin/env bash

set -e # Stop on errors

die() {
	echo -e "\e[91m${*}\e[m"
	exit 1
}

BUILDER_SOURCE="$(dirname "${0}")"
cd "${BUILDER_SOURCE}"
# We make sure lib.sh file exists and we source it
[[ -f "lib.sh" ]] || die "Missing file lib.sh!"

source "lib.sh" # This file contains some utils and other librairies sourcing

debug "Args: ${*}"
cd ..
ROOT="$(pwd)"
[[ -f "${ROOT}/build" ]] || mkdir -p "${ROOT}/build"
BUILD_FILE="${ROOT}/packages/${1}/Build.sh"
if [[ ! -f "${BUILD_FILE}" ]]
then
	red "Invalid package: ${1}"
fi
PKGDIR="${ROOT}/tmp/${1}"
export DESTDIR="${PKGDIR}/rootfs"
MAKEFLAGS="-j$(nproc)"
export MAKEFLAGS
[[ -f "${DESTDIR}" ]] && rm -rf "${DESTDIR}"

mkdir -p "${DESTDIR}"

source "${BUILD_FILE}"
cyan "Building ${NAME} version ${VERSION}"
[[ -f "${PKGDIR}/sources" ]] && rm -rf "${PKGDIR}/sources"
mkdir -p "${PKGDIR}/sources"
cd "${PKGDIR}/sources"
for ARC in ${SRC}
do
	wget "${ARC}"
done
extract
[[ -z "${WD}" ]] && WD="${NAME}-${VERSION}"
cd "${PKGDIR}/sources/${WD}"
call_if_def "prepare" # Call the build preparation
call_if_def "build"
call_if_def "install"
SULF_PKG_DIR="${PKGDIR}/sulfbuild"
[[ -f "${SULF_PKG_DIR}" ]] && rm -rf "${SULF_PKG_DIR}"
mkdir -p "${SULF_PKG_DIR}"
cd "${SULF_PKG_DIR}"
cp -r "${DESTDIR}"/* "${SULF_PKG_DIR}"
cat << EOF > "${SULF_PKG_DIR}/.PKG"
name = ${NAME}
version = ${VERSION}
subversion = 1
architecture = x64
packager = ${USER}
url = ${HOMEPAGE}
EOF
touch "${SULF_PKG_DIR}/.INSTALL"
tar czf "${ROOT}/build/${NAME}-${VERSION}.tar.zst" . 
