@echo off

if "%_echo%"=="on" @echo on

SET ROOTDIR=%~dp0
SET ROOT=%~dp0
@REM SET VIM=%~dp0..\vim
SET VIM=C:\vim
@SET JAVA_HOME=C:\Program Files\Java\jdk1.6.0_34
SET JAVA_HOME=C:\Program Files\Java\jdk1.7.0_25
@REM SET ANT_HOME=D:\misc\apache-ant-1.8.4
@REM SET BOOST_ROOT=D:\misc\boost_1_52_0
@REM SET MINGW_ROOT=D:\misc\qt\mingw

::Set Vim Path
PATH=%PATH%;%~dp0;%~dp0..
@REM FOR /D %%D IN (%VIM%\..) DO CALL :SETGLOBALPATH %%~dpnxD
FOR /D %%D IN (%VIM%\vim74) DO CALL :SETGLOBALPATH %%~dpnxD

::Set Path to include all under sw
FOR /D %%D IN (%~dp0..\*) DO CALL :SETGLOBALPATH %%~dpnxD

::Set d:\tools
FOR /D %%D IN (D:\tools\*) DO CALL :SETGLOBALPATH %%~dpnxD

Title MyStudio - Just Smile:-)
prompt $+$P$_[$T$H$H$H]$$$S
doskey /MACROFILE=%~dp0\alias.pub
cd /d %~dp0..

SET /A DEFFIREFOXNUMBER=1
REM FOR /F "tokens=1,2*" %%I in ('tasklist /NH /fi "imagename eq firefox.exe"') DO (
REM     IF "%%I"=="firefox.exe" SET /A DEFFIREFOXNUMBER+=1
REM )

GOTO :EOF

:SETGLOBALPATH
IF EXIST %1\bin (
    PATH=%PATH%;%1\bin
) ELSE (
    PATH=%PATH%;%1
)
GOTO :EOF
