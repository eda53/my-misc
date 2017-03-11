@REM collecting files.
IF EXIST files.cs.txt DEL files.cs.txt
@ECHO Collecting %~dp0...
FOR /R %%F in (*.h *.hpp *.inl *.hrh *.cpp *.c *.cc *.java *.xml *.pl *.py *.vhd *.tcl *.mk  *.mak) DO @ECHO %%~pnxF>>files.cs.txt
:Cycle
IF NOT "%~1"=="" (
    @ECHO Collecting %~1...
    FOR /R %1 %%F in (*.h *.hpp *.inl *.hrh *.cpp *.c *.cc *.java *.xml *.pl *.py *.vhd *.tcl *.mk  *.mak) DO @ECHO %%~pnxF>>files.cs.txt
    SHIFT /1 & GOTO :Cycle
)

@ECHO Generating cscope database...
cscope.exe -kb -i files.cs.txt
