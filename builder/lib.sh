#!/usr/bin/env bash

# Builder lib

# Prints a text in red
# Usage: red "text"

red() {
	echo -e "\e[91m${*}\e[m"
}

# Prints a text in cyan
# Usage: cyan "text"

cyan() {
	echo -e "\e[96m${*}\e[m"
}

# Prints a debug message in yellow
# Usage: debug "text"

debug() {
	if [[ -n "${DEBUG}" ]]
	then
		echo -e "\e[93m[DEBUG] ${*}\e[m"
	fi
}

# Call a function only if it is defined
# Usage: call_if_def fun
call_if_def() {
	if [[ "$(command -v "${1}")" ]]
	then
		"${1}"
	else
		debug "Skipping calling ${1} because it doesn't exist"
	fi
}
