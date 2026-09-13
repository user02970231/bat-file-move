@REM ############################################################################
@REM Windows日本語環境用
@REM ファイル移動&クリップボードへコピーするtool
@REM 親ディレクトリにあるファイルをターゲットに設定して自由にファイル移動が可能
@REM Japanese (Shift JIS) で保存
@REM ############################################################################

@REM cls
@echo off
chcp 932 >nul
setlocal enabledelayedexpansion
pushd "%~dp0"


@REM ========================
@REM ファイルチェック
@REM ========================
if "%~1"=="" (
    echo ファイルが指定されていません。ファイルをドロップしてください。
    echo 終了するには何かキーを押してください。
    pause >nul
    exit /b
)


@REM ========================
@REM ペースト先ターゲットファイル(数字や名前などに対応)
@REM ========================

:: ターゲット設定
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
    echo 送り先のフォルダーが見つかりませんでした。
    pause >nul
    exit /b
)


@REM ========================
@REM 送り先の選択処理
@REM ========================
set "fcount="
echo ========================
echo 送り先を選択してください。
echo ========================
for /l %%c in (1,1,%counts%) do (
    echo %%c : !fname[%%c]!
    set "fcount=!fcount!%%c"
)
echo ========================

choice /c !fcount! /n /m "送り先の番号を入力してください"

set "transname=!fname[%errorlevel%]!"
set "transpath=!fpath[%errorlevel%]!"
@REM echo !transname!
@REM echo !transpath!




@REM ========================
@REM 移動処理 & フォルダ名のコピー
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
echo "!transname!"へ移動しました



set "clipboard=%~dp0\clip.txt"
if exist "!clipboard!" del "!clipboard!" 2>nul
for %%c in (%*) do (
    set "filename=%%~nxc"
    echo !filename!>>"!clipboard!"
)
clip < !clipboard!
del !clipboard!
echo ファイル名をクリップボードにコピーしました！
pause
