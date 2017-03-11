@ECHO OFF

FOR /F "tokens=1,2* " %%E IN ('findstr /C:"M    " svn.status.txt') DO (
	svn diff --diff-cmd svndiff.cmd %%F
)
