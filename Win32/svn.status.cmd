@ECHO OFF
svn status > svn.status.0
findstr /C:"M    " svn.status.0 > svn.status.txt
findstr /C:"A    " svn.status.0 >> svn.status.txt
findstr /C:"D    " svn.status.0 >> svn.status.txt
findstr /C:"X    " svn.status.0 >> svn.status.txt
findstr /C:"?    " svn.status.0 >> svn.status.txt
del /f /q svn.status.0
