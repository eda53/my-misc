#!/bin/bash

reverse_from_to='no'
[ "$1" == "-r" ] && reverse_from_to='yes' && shift

vimdiff='no'
[ "$1" == '-v' ] && vimdiff='yes' && shift
[ "$1" == "-r" ] && reverse_from_to='yes' && shift

vimdiff_dir() {
	from=$1
	to=$2
	dry_run=' -n '
	exclude=''
   	exclude='--exclude *.o '$exclude
	exclude='--exclude *.P '$exclude
	exclude='--exclude *.q '$exclude
	exclude='--exclude *.svn* '$exclude
	exclude='--exclude *.git* '$exclude

	for fil in $(eval rsync -av "$dry_run" "$exclude" "$from/" "$to/" | sed '1d;/^$/q' | sed 's/ \+->.\+//'); do
		filename=`basename $fil`
		fileext=${filename##*.}

		[ ! -d "${from}/${fil}" -a ! -f "${from}/${fil}" ] && \
			{ echo "${from}/${fil}   MISSED!"; continue; }
		[ ! -d "${to}/${fil}"   -a ! -f "${to}/${fil}"   ] && \
			{ echo "${to}/${fil}   MISSED!"; continue;   }

		[ -f "${from}/${fil}" -a ! -h "${from}/${fil}" -a -f "${to}/${fil}" ] && \
			[ "$fileext" != "jpg" -a "$fileext" != "png" -a "$fileext" != "P" ] && \
		   	(file "${from}/${fil}" | grep -q "ELF"   || \
			 diff -q "${from}/${fil}" "${to}/${fil}" || \
			 vimdiff "${from}/${fil}" "${to}/${fil}")
	done
}

if [ -d "$2" -a -d "$1" ]; then
	vimdiff_dir $1 $2
elif [ -z "$1" -o ! -f "$1" ]; then
	echo "$0 -r <sync-dirs-list.txt> [yes]"
	return 2>/dev/null || exit
else
	. $1
fi
dry_run=' -n'
[ "$2" = "yes" ] && dry_run='' && vimdiff='no'

get_from () {
	str="$1"
	from=${str%;to:*}
	echo "${from#from:}"
}

get_to () {
	str="$1"
	to=${str#from:*;to:}
	echo "${to%;exclude:*}"
}

get_excl () {
	str="$1"
	excl=${str#*;exclude:}
	excl2=${excl// / --exclude }
	excl3=${excl2%;*}
	[ -n "$excl3" -a "${excl3:0:2}"!="--" ] && excl3="--exclude $excl3"
	echo "$excl3"
}

if [ "$reverse_from_to" == "yes" ]; then
	for dir in "${dirs[@]}"; do
		to=$(get_from "$dir")
		from=$(get_to "$dir")
		exclude=$(get_excl "$dir")
		echo rsync -av "$dry_run" "$exclude" "$from/" "$to/"
		if [ "$vimdiff" == 'no' ]; then
			eval rsync -av "$dry_run" "$exclude" "$from/" "$to/"
		else
			for fil in $(eval rsync -av "$dry_run" "$exclude" "$from/" "$to/" | sed '1d;/^$/q' | sed 's/ \+->.\+//'); do
				#[ -f "${from}/${fil}" -a -f "${to}/${fil}" ] && (file "${from}/${fil}" | grep -q "ELF" || vimdiff ${from}/${fil} ${to}/${fil})
				filename=`basename $fil`
				fileext=${filename##*.}
#				[ -f "${from}/${fil}" -a -f "${to}/${fil}" ] && [ "$fileext" != "jpg" -a "$fileext" != "png" ] &&  (file "${from}/${fil}" | grep -q "ELF" || diff -q ${from}/${fil} ${to}/${fil} || vimdiff ${from}/${fil} ${to}/${fil})
				[ -f "${from}/${fil}" -a ! -h "${from}/${fil}" -a -f "${to}/${fil}" ] && [ "$fileext" != "jpg" -a "$fileext" != "png" ] &&  (file "${from}/${fil}" | grep -q "ELF" || diff -q ${from}/${fil} ${to}/${fil} || vimdiff ${from}/${fil} ${to}/${fil})
			done
		fi
	done
else
	for dir in "${dirs[@]}"; do
		from=$(get_from "$dir")
		to=$(get_to "$dir")
		exclude=$(get_excl "$dir")
		echo rsync -av "$dry_run" "$exclude" "$from/" "$to/"
		if [ "$vimdiff" == 'no' ]; then
			eval rsync -av "$dry_run" "$exclude" "$from/" "$to/"
		else
			for fil in $(eval rsync -av "$dry_run" "$exclude" "$from/" "$to/" | sed '1d;/^$/q' | sed 's/ \+->.\+//'); do
				#[ -f "${from}/${fil}" -a -f "{to}/${fil}" ] && ! (file "${from}/${fil}" | grep -q "executable") && vimdiff ${from}/${fil} ${to}/${fil}
				filename=`basename $fil`
				fileext=${filename##*.}
				[ -f "${from}/${fil}" -a ! -h "${from}/${fil}" -a -f "${to}/${fil}" ] && [ "$fileext" != "jpg" -a "$fileext" != "png" ] &&  (file "${from}/${fil}" | grep -q "ELF" || diff -q ${from}/${fil} ${to}/${fil} || vimdiff ${from}/${fil} ${to}/${fil})
			done
		fi
	done
fi
