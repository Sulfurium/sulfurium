#!/usr/bin/env bash
ROOT=`dirname $0`
cd $ROOT
if [[ -d "${ROOT}/build" ]]
then
	rm -rf "${ROOT}/build"
fi
mkdir "${ROOT}/build"
if [[ -d "${ROOT}/temp" ]] 
then
	rm -rf "${ROOT}/temp"
fi
mkdir "${ROOT}/temp"
if [[ -n "${1}" ]]
then
	if [[ -d "${ROOT}/packages/${1}/" ]]
	then
		if [[ ! -x "${ROOT}/packages/${1}/build.sh" ]]
		then
			echo "Missing build script for ${1}!"
			exit 1
		fi
		"${ROOT}/packages/${1}/build.sh" $PWD
		exit
	fi
fi
PKGS=($ROOT/packages/*)
for PKG in ${PKGS[*]}
do
	echo "Building ${PKG}..."
	if [[ ! -x "${PKG}/build.sh" ]] 
	then
		echo "Missing build script for ${PKG}!"
	else
		"${PKG}/build.sh" $PWD
	fi
done
