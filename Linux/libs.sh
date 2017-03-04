#!/bin/sh

DIR=.
[ -n "$1" ] && DIR=$1

for f in $(find $DIR -type f -exec file {} \; | grep 'ELF' | cut -f 1 -d ':'); do
	echo "==> $f";
	readelf -a $f | grep "Shared library:" | cut -f 2 -d '[' | cut -f 1 -d ']';
	echo "";
done
