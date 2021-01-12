#!/usr/bin/env bash
ROOT=`dirname $0`
cd $ROOT
if [[ ! -d "${ROOT}/build" ]]
then
	mkdir "${ROOT}/build"
fi
if [[ ! -d "${ROOT}/temp" ]] 
then
	mkdir "${ROOT}/temp"
fi
if [[ -n "${1}" ]]
then
	if [[ -d "${ROOT}/packages/${1}/" ]]
	then
		if [[ ! -x "${ROOT}/packages/${1}/build.sh" ]]
		then
			echo "Missing build script for ${1}!"
			exit 1
		fi
		PKG="${ROOT}/packages/${1}"
		if [[ -f "${PKG}/DEPENDS" ]]
		then
			source "${PKG}/DEPENDS"
			for DEP in "${DEPS[*]}" 
			do
				if [[ ! -x "${ROOT}/packages/${DEP}/build.sh" ]]
				then
					echo -e "\e[91mMissing build script for ${DEP}"
					exit 1
				fi
				"${ROOT}/packages/${DEP}/build.sh" $PWD || exit 1
			done
		fi
		"${PKG}/build.sh" $PWD || exit 1
	fi
fi
COMPILED=()
PKGS=($ROOT/packages/*)
for PKG in ${PKGS[*]}
do
	echo "Building ${PKG}..."
	echo $PKG
	if [[ ! -x "${PKG}/build.sh" ]] 
	then
		echo "Missing build script for ${PKG}!"
	else
		if [[ -f "${PKG}/DEPENDS" ]]
		then
			source "${PKG}/DEPENDS"
			for DEP in "${DEPS[*]}" 
			do
				if [[ " ${COMPILED[@]} " =~ "${ROOT}/packages/${DEP}" ]]
				then
					return 
				fi
				if [[ ! -x "${ROOT}/packages/${DEP}/build.sh" ]]
				then
					echo -e "\e[91mMissing build script for ${DEP}"
					exit 1
				fi
				"${ROOT}/packages/${DEP}/build.sh" $PWD || exit 1
				COMPILED+=($ROOT/packages/$DEP)
			done
		fi
		"${PKG}/build.sh" $PWD || exit 1
		COMPILED+=($PKG)
	fi
done
