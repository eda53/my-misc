#! /bin/sh
#
# harden_svnext.sh
# Copyright (C) 2022 eda <eda@evertz.com>
#
# Distributed under terms of the Evertz Proprietary license.
#

[ '--force' = "$1" ] && { FORCED=1; shift; }
SVNDIR="$1"
[ -z "$SVNDIR" ] && SVNDIR='.'
readonly SVNDIR

[ -z "$VERBOSE" ] && VERBOSE=0
[ -z "$FORCED"  ] && FORCED=0
ALL_DIRS="$(find $SVNDIR -type d -not \
	\( -path '*/.svn*'       -o \
	   -path '*/rootfs*'     -o \
	   -path '*/fpga_api*'   -o \
	   -path '*/.git*' \)   \
	-exec sh -c 'svn pl {} 2>/dev/null | grep -q svn:externals' \; -print)"
for d in $ALL_DIRS; do
	if [ "$FORCED" = "1" ] || svn pg svn:externals $d | grep -v '#' | grep -v '@' | grep -v -e '^[[:space:]]*$'; then
		echo "==> harded directory:{$d}..."
		svn pe svn:externals "$d"
		echo "==> done"
	else
		echo "==> {$d} already harded!"
		[ "$VERBOSE" = '0' ] || svn pg svn:externals "$d"
	fi
done
