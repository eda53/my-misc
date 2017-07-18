#! /bin/sh
#
# svn.mi.sh
# Copyright (C) 2017 eda <eda@engub>
#
# Distributed under terms of the MIT license.
#


if [ -z "$1" ]; then
	svn mergeinfo .
	svn propget svn:mergeinfo .
else
	svn mergeinfo $@
	svn propget svn:mergeinfo $@
fi
