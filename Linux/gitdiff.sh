#!/bin/bash

# Configure your favorite diff program here.
DIFF="/usr/bin/vimdiff"
#DIFF="/home/ethan/.bin/diff2html.svn.sh"

# Subversion provides the paths we need as the sixth and seventh
# parameters.
LEFT=${1}
RIGHT=${2}
EXT="${RIGHT##*.}" 
if [ "$RIGHT" = "$EXT" ]; then
	FILE="$(file $RIGHT)"
	if echo "$FILE" | grep -i 'Squashfs'; then
		EXT='sqsh'
	elif echo "$FILE" | grep -i 'gzip'; then
		EXT='tgz'
	elif echo "$FILE" | grep -i 'bzip2'; then
		EXT='bz2'
	elif echo "$FILE" | grep -i 'ar archive'; then
		EXT='a'
	elif echo "$FILE" | grep -i 'Device Tree Blob'; then
		EXT='dtb'
	fi
fi

# Call the diff command (change the following line to make sense for
# your merge program).
# .sqsh is supported via --force option.
if [ 'sqsh' = "$EXT" ]; then
	$DIFF <(unsquashfs -ll $LEFT  | sed 's/.\+-root\///') \
	      <(unsquashfs -ll $RIGHT | sed 's/.\+-root\///')
elif [ 'tgz' = "$EXT" -o 'gz' = "$EXT" ]; then
	$DIFF <(tar -tzvf $LEFT) <(tar -tzvf $RIGHT)
elif [ 'bz2' = "$EXT" ]; then
	$DIFF <(tar -tjvf $LEFT) <(tar -tjvf $RIGHT)
elif [ 'a' = "$EXT" ]; then
	$DIFF <(ar -t $LEFT) <(ar -t $RIGHT)
elif [ 'dtb' = "$EXT" ]; then
	$DIFF <(dtc -I dtb -O dts $LEFT) <(dtc -I dtb -O dts $RIGHT)
else
	$DIFF $LEFT $RIGHT
fi

# Return an errorcode of 0 if no differences were detected, 1 if some were.
# Any other errorcode will be treated as fatal.
