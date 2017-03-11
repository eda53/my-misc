@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

IF "%~1"=="" ECHO "ip?" & GOTO :EOF

SET /A CNT=1

:Cycle
PING -n 1 -w 500 %1 2>&1 1>NUL
IF %ERRORLEVEL% NEQ 0 SET /A CNT=1 & GOTO :Cycle
SET /A CNT=%CNT%+1
ECHO %CNT%
IF %CNT% LSS 10 GOTO :Cycle

REM telnet %1
@REM start "" /MAX C:\Users\eda\Work\tools\teraterm-4.83\ttermpro.exe /T=1 /P=23 %*
SET LOGD=E:\projects\zzLogs
SET TTLF="%TEMP%\ptelnet.ttl"
CALL :InitConnect %TTLF%
ttpmacro.exe %TTLF% %LOGD% %*
del /f /q %TTLF%
GOTO :EOF

:InitConnect
(
ECHO sprintf "%%s:23 /nossh /T=1" param3
ECHO connect inputstr
ECHO.
ECHO gettime timestr "%%Y%%m%%d-%%H%%M%%S"
ECHO sprintf2 logf '%%s\%%s_pt_%%s.log' param2 timestr param3
ECHO logopen logf 0 1 1 1 1 0
ECHO.
ECHO wait 'login:'
ECHO sendln 'root'
ECHO wait 'assword:'
ECHO sendln 'xxxxx'
ECHO.
) > %1
GOTO :EOF
