#!/bin/bash

# generate patch under current folder:
# please redirect result to the file NOT under the current folder!!

git diff
git ls-files --others --exclude-standard | while read -r i; do git diff -- /dev/null "$i"; done
