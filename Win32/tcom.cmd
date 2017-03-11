@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

IF "%~1"=="" ECHO "COM port?" & GOTO :EOF
SET COMPORT=%~1

SET LOGD=E:\projects\zzLogs
IF NOT "%~2"== "" SET LOGD="%~2"

REM telnet %1
SET TTLF="%TEMP%\pcom.ttl"
CALL :InitConnect %TTLF%
ttpmacro.exe %TTLF% %LOGD% %COMPORT%
del /f /q %TTLF%
GOTO :EOF

:InitConnect
(
ECHO sprintf "/BAUD=115200 /C=%%s" param3
ECHO connect inputstr
ECHO if result ^<^> 2 then
ECHO    messagebox inputstr 'Error'
ECHO    closett
ECHO    exit
ECHO endif
ECHO.
ECHO gettime timestr "%%Y%%m%%d-%%H%%M%%S"
ECHO sprintf2 logf '%%s\%%s_COM%%s.log' param2 timestr param3
ECHO ; logopen ^<filename^> ^<binary flag^> ^<append flag^> ^[^<plain text flag^> ^[^<timestamp flag^> ^[^<hide dialog flag^> ^[^<Include screen buffer^>^]^]^]^]
ECHO logopen logf 0 1 1 1 1 0
ECHO.
ECHO sendln
ECHO wait 'login:' 'platform:' 'root@' '^>'
ECHO if result == 1 then
ECHO    sendln 'root'
ECHO    wait 'assword:'
ECHO    sendln 'xxxxx'
ECHO endif
ECHO.
) ^> %1
GOTO :EOF
