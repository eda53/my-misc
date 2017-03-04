#!/bin/sh

for fil in `find . -name '*.cpp' -type f -not -path '*.svn*' -exec grep -q DBGP {} \; -printf '%p '`; do
	echo "  processing {$fil}..."
	sed -i "s/^#define[ \t]\+.\+DBGP/\/\/&/" $fil
	sed -i "s/[a-zA-Z0-9_-]\+DBGP/DBGP/" $fil
done
