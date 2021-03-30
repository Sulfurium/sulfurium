#!/usr/bin/env bash

NAME="hello"
DESCRIPTION="GNU hello world implementation"
VERSION="2.10"
SRC=("https://ftp.nluug.nl/pub/gnu/hello/hello-${VERSION}.tar.gz")
HOMEPAGE="https://www.gnu.org/software/${NAME}/"
extract() {
	tar xf "${NAME}-${VERSION}.tar.gz"
}
prepare() {
	./configure --prefix=/usr
}

build() {
	make # We don't need additionnal arguments like core number since MAKEFLAGS is set
}

install() {
	make install # DESTDIR is already set
}
