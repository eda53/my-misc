#!/bin/sh

if [ ! -d "$1" -o ! -d "$2" -o ! -d "$3" ]; then
    echo "1: old folder\n2: new folder\n3: output folder"
    exit 1;
fi

#pushd $1 > /dev/null

for fil in `find $1 -type f -not -wholename '*.svn*' -printf "%P "`; do
    echo -n "process file{$fil}."
    if [ -f $2/$fil ]; then
        echo -n "\tfound."
        if [ -n "`diff -qEBwb $1/$fil $2/$fil`" ]; then
            echo -n "\tgenerating diff..."
            ~/.bin/diff2html -EBwb $1/$fil $2/$fil > $3/`basename $2`_`basename $fil`.html
        fi
    fi
    echo "\t\t\tdone"
done

#popd > /dev/null
