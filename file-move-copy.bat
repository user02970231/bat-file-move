@REM ############################################################################
@REM Tool for moving files and copying to the clipboard
@REM You can freely move files by setting a file in the parent directory as the target.
@REM Japanese (Shift JIS) 
@REM ############################################################################

@REM cls
@echo off
chcp 932 >nul
setlocal enabledelayedexpansion
pushd "%~dp0"


@REM ========================
@REM file check
@REM ========================
if "%~1"=="" (
    echo No file has been specified. Please drop a file.
    echo Press any key to exit.
    pause >nul
    exit /b
)


@REM ========================
@REM target file
@REM ========================

:: Target Setting
set "targets=001 002 005 斎藤"
set counts=0

for /d %%T in ("..\*") do ( 
    echo "%%~fT" | findstr /i "%targets%" >nul
    if !errorlevel! equ 0 (
        set /a counts+=1
        set "fpath[!counts!]=%%~fT"
        set "fname[!counts!]=%%~nT"
    )
)
if %counts%==0 (
    echo The destination folder was not found.
    pause >nul
    exit /b
)


@REM ========================
@REM Recipient selection process
@REM ========================
set "fcount="
echo ========================
echo Please select a recipient.
echo ========================
for /l %%c in (1,1,%counts%) do (
    echo %%c : !fname[%%c]!
    set "fcount=!fcount!%%c"
)
echo ========================

choice /c !fcount! /n /m "Please enter the recipient's number."

set "transname=!fname[%errorlevel%]!"
set "transpath=!fpath[%errorlevel%]!"
@REM echo !transname!
@REM echo !transpath!




@REM ========================
@REM Move Operation & Copy Folder Name
@REM ========================

echo ========================
for %%F in (%*) do (
    @REM echo [debug] %%~nxF
    @REM echo %%~F
    set "transfile=%%~nxF"
    
    if exist "%%~F\" (
        robocopy "%%~F" "!transpath!\!transfile!" /move /e /ndl /np /njs /njh /nfl
        echo "!transfile!"
    ) else (
        robocopy "%~dp0." "!transpath!" "!transfile!" /mov /ndl /np /njs /njh /nfl
        echo "!transfile!"
    )   
)
echo ========================
echo "!transname!" moved



set "clipboard=%~dp0\clip.txt"
if exist "!clipboard!" del "!clipboard!" 2>nul
for %%c in (%*) do (
    set "filename=%%~nxc"
    echo !filename!>>"!clipboard!"
)
clip < !clipboard!
del !clipboard!
echo The file name has been copied to the clipboard!
pause
