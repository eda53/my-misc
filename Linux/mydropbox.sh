#!/bin/sh -e

[ -z "$1" ] && echo "files or folders??" && exit

PASSWD='MYPASSWORD'

todp () {
	FILENAME="$(date '+%d%m%y%H%M%S%N')"
	tar --exclude '*.svn*' --exclude '*.git*' --exclude '*CVS*' --exclude '*.o' --exclude '*.P' -czvf ${FILENAME}.tgz $@ && \
	zip -m --password $PASSWD ${FILENAME}.zip ${FILENAME}.tgz && \
	mv ${FILENAME}.zip ~/Dropbox/
}

fromdp () {
	unzip -pP $PASSWD "$1" | tar -xzvf -
}

$(basename $0) $@
