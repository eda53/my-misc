#! /bin/sh
#
# svn.ext.sh
# Copyright (C) 2017 eda <eda@engub>
#
# Distributed under terms of the MIT license.
#


svn_externals='svn_externals'
[ -z "$1" ] ||  svn_externals="$1"

svn propedit svn:externals $svn_externals
