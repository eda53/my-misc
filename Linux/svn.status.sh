svn status > svn.status.0 || (rm svn.status.0 && exit -1)
grep ^M svn.status.0 > svn.status.txt
grep ^A svn.status.0 >> svn.status.txt
grep ^D svn.status.0 >> svn.status.txt
grep ^? svn.status.0 >> svn.status.txt
egrep '^\?.*((\.[^Poqd])|([^\.].))$' svn.status.0 >> svn.status.txt
rm -f svn.status.0
head svn.status.txt
