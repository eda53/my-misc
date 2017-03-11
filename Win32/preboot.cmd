@ECHO OFF

IF "%~1"=="" ECHO "ip?" & GOTO :EOF

SET /A CNT=1

:Cycle
PING -n 1 -w 500 %1 2>&1 1>NUL
IF %ERRORLEVEL% NEQ 0 SET /A CNT=1 & GOTO :Cycle
SET /A CNT=%CNT%+1
ECHO %CNT%
IF %CNT% LSS 10 GOTO :Cycle

REM telnet %1
SET LOGD=D:\projects\Log
SET TTLF="%TEMP%\preboot.ttl"
CALL :InitConnect %TTLF%
ttpmacro.exe %TTLF% %LOGD% %*
del /f /q %TTLF%
GOTO :EOF

:InitConnect
REM ECHO logopen logf 1 1 1 1 1 0
(
ECHO sprintf "%%s:23 /nossh /T=1" param3
ECHO connect inputstr
ECHO.
ECHO gettime timestr "%%Y%%m%%d-%%H%%M%%S"
ECHO sprintf2 logf '%%s\pt_%%s_%%s.log' param2 param3 timestr
ECHO.
ECHO wait 'login:'
ECHO sendln 'root'
ECHO wait 'assword:'
ECHO sendln 'xxxxx'
ECHO.
ECHO wait 'root@'
ECHO sendln 'sync'
ECHO wait 'root@'
ECHO sendln 'sync'
ECHO wait 'root@'
ECHO sendln 'reboot'
) > %1
GOTO :EOF
