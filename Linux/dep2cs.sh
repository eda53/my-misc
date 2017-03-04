#!/bin/bash

OUT=$PWD/cscope.files
[ -n "$1" ] && pushd

get_dep_files()
{
#	sed -r -e 's/^\s+//g' | sed -r -e 's/\s*[\\:]?\s*$//g' | sed -r -e 's/\S+.o:\s+//g'
	sed -r -e 's/\s+/\n/g' | sed -r -e '/\\$/d; /.[oa]:?$/d; /.bin:$/d; /^$/d; /^:$/d' | sort -u
}


FILES=$(find . -name '*.P')
if [[ -z $FILES ]]; then
	echo "No *.P found"
else
	cat $FILES | sort | uniq | get_dep_files | xargs -d '\n' -I '{}' readlink -f {} >> $OUT.1
fi

for file in `find . -name .depend`; do
	pushd $(dirname $file) >/dev/null
	echo "processing $file ..."
	cat $(basename $file) | get_dep_files | sort | uniq | xargs -d '\n' -I '{}' readlink -f {} >> $OUT.1
#	cat .depend | get_dep_files | sort | uniq >> $OUT.1
	popd >/dev/null
done

for file in $(find . -name '*.d'); do
	echo "processing $file ..."
#	cat $FILES | sort | uniq | get_dep_files | xargs -d '\n' -I '{}' readlink -f {} > $OUT.1
	cat $file | sort | uniq | get_dep_files >> $OUT.1
done


sort -u $OUT.1 > $OUT
rm $OUT.1

[ -n "$1" ] && popd
