@echo off

if "%_echo%" == "on" @echo on

::save current dir
pushd .

::chdir
if /I "%~1" == "java" (
cd /d "%~dp0\..\Java\%~2"
goto :EOF
)

if /I "%~1" == "crack" (
cd /d "%~dp0\..\..\CrackEr\%~2"
goto :EOF
)

if /I "%~1" == "j2sdk" (
cd /d "C:\j2sdk1.4.2_05\%~2"
goto :EOF
)

if /I "%~1" == "wtk" (
cd /d "C:\WTK22\%~2"
goto :EOF
)

if /I "%~1" == "MotoSDK" (
cd /d "%ProgramFiles%\MotoSDK\EmulatorM.3\bin\%~2"
goto :EOF
)

if /I "%~1" == "Moto" (
cd /d "%~dp0\..\..\Moto\%~2"
goto :EOF
)

if /I "%~1" == "vim" (
cd /d "%ProgramFiles%\vim\vim63\%~2"
goto :EOF
)

if /I "%~1" == "doc" (
cd /d "d:\document\ProgramDev\%~2"
goto :EOF
)

if /I "%~1" == "proxy" (
cd /d "%~dp0\..\importProxy2Maxthon\%~2"
goto :EOF
)

if /I "%~1" == "sys" (
cd /d "%SystemRoot%\System32\%~2"
goto :EOF
)

if /I "%~1" == "vc" (
cd /d "%~dp0\..\vc71\%~2"
goto :EOF
)

if /I "%~1" == "win" (
cd /d "%SystemRoot%\%~2"
goto :EOF
)

if /I "%~1" == "IETemp" (
cd /d "%USERPROFILE%\Local Settings\Temporary Internet Files\Content.IE5\%~2"
goto :EOF
)

if /I "%~1" == "Torrent" (
cd /d "%ProgramFiles%\BitComet\Torrents\%~2"
goto :EOf
)

if /I "%~1"=="WordList" (
cd /d "%ProgramFiles%\Kingsoft\PowerWord 2005\ScrollWord\WordList\%~2"
goto :EOF
)

if /I "%~1"=="NewWord" (
cd /d "%APPDATA%\Kingsoft\Powerword\Newword\%~2"
goto :EOF
)

if /I "%~1"=="WordWave" (
cd /d "F:\WordWave\%~2"
goto :EOF
)

if /I "%~1"=="e" (
cd /d "D:\Software\Moto\E680I\%~2"
goto :EOF
)

if /I "%~1"=="GRE" (
cd /d "D:\English\GRE\%~2"
goto :EOF
)

::not chdir,so pop it;
popd

if "%~1" == "" (
echo goto [Java ^| vc ^| j2sdk ^| vim ^| doc ^| proxy ^| sys ^| win ^| IETemp ^| Torrent ^| WordList ^| NewWord ^| WordWave ^| e]
goto :EOF
)

Echo %~1 Not support !
