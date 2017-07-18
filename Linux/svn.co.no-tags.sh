#! /bin/sh -e
#
# svn.co.no-tags.sh
# Copyright (C) 2017 eda <eda@bobbuilder>
#
# Distributed under terms of the MIT license.
#


svn co --depth immediates $@

if [ -n "$2" ]; then
	cd "$2"
else
	cd "$(basename $1)"
fi

[ ! -d tags ] || svn up --set-depth exclude tags
find . -maxdepth 1 -type d -not -name '.' -not -name '..' -exec svn up --set-depth infinity {} \;
