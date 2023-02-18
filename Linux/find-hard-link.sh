#!/bin/bash

DIR="$1"
[ -n "$DIR" ] || DIR='.'

#find $DIR -xdev ! -type d -links +1 -printf '%20D %20i %p\n' | sort -n | uniq -w 42 --all-repeated=separate
find $DIR -xdev ! -type d -printf '%-10i %-10k %p\n' | sort -n
