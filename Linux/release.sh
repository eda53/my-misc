#!/bin/bash

if [ "$1" != "yes" ]; then
	echo "bye-bye"
	exit 0;
fi

TODAY=`date +"%Y-%m-%d"`
#LOGFILE="release.`date +"%Y-%m-%d_%H-%M-%S"`.log"
LOGFILE="release.`date +"%Y-%m-%d"`.log"

my_exec() {
	echo '==> Executing ['"$1"']...' | tee -a $LOGFILE
	eval "$1" 2>&1 | tee -a $LOGFILE
}

my_exec 'rm -rf ella-rtx'
my_exec 'rm -rf udcj2k-rtx'
my_exec 'make -f makefile.template distclean'

my_exec 'svn up'
my_exec 'cd cvs_externals; make -f cvs_externals.mk update; cd ..;'
my_exec 'svn status'
#my_exec 'svn.status.sh && svn.diff --batch'
my_exec 'svn.status.sh && svn.diff'
my_exec 'cp -f svn.status.txt svn.status.$TODAY.txt && svn.diff --batch>> svn.status.$TODAY.txt'

my_exec 'make -f makefile.template udcj2k'
