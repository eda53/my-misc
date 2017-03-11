@ECHO OFF

IF "%~1"== "" GOTO :Usage

start /B "" "c:\Program Files\sun\VirtualBox\VBoxHeadless.exe" -startvm  %1 2>NUL 1>&2
GOTO :EOF

:Usage
echo missing sth?
:EOF
