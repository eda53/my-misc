@ECHO  OFF

GOTO :ShitCMD
REM Do you know what's wrong with below code ^_^
If "%~1"=="-" (
  SET OLD_MYCD=%-%
  SET -=%CD%
  CD /D %OLD_MYCD%
) ELSE (
  SET -=%CD%
  CD %*
)

:ShitCMD

IF "%~1"=="" CD & GOTO :EOF
IF "%~1"=="-" GOTO :PrevCD
SET OLD_MYCD=%CD%
CD /D %*
IF NOT "%CD%"=="%OLD_MYCD%" SET -=%OLD_MYCD%
SET OLD_MYCD=
GOTO :EOF

:PrevCD
SET OLD_MYCD=%-%
SET -=%CD%
CD /D %OLD_MYCD%
SET OLD_MYCD=
GOTO :EOF
