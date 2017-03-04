#!/bin/bash

#make vsyssrv_clean > /dev/null 2>&1

#. lib/hal/xpt/sync.sh

#cp_files=$(make -n | grep 'cp ')

if [ -f "$1" ]; then
	fdir=$(dirname $1)
	if [ -d "$fdir/build" ]; then
		bdir="$fdir/build"
	elif [ -d "$fdir/../build" ]; then
		bdir="$fdir/../build"
	else
		bdir="$fdir"
	fi
	make  V=1 -C $bdir
	make  V=1 -C $bdir
else
	make V=1 $*
fi

# echo "========== Copy generated files to /import/tftproot as well ============="
cmd=""
for cf in $cp_files; do
	if [ "$cf" = "cp" -a -n "$cmd" ]; then
		cmd="$cmd /import/tftproot/"
		eval "$cmd"
		cmd=""
	else
		cmd="$cmd $last_cf"
	fi
	last_cf=$cf
done
if [ -n "$cmd" ]; then
	cmd="$cmd /import/tftproot/"
	eval "$cmd"
fi

