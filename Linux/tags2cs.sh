#!/bin/bash

if [ -z "$1" -o ! -e "$1" ]; then
	echo "$0 tags"
	exit 1;
fi

sed -e '/^!/d' \
    -e 's/^[^\t]\+\t\+//' \
    -e 's/\t\+.\+$//' \
    <$1 >cs.1

sort cs.1 | uniq > cscope.files
rm -f cs.1
