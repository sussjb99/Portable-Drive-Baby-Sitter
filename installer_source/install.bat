@echo off
title Portable Drive Baby Sitter - Installer
color 0F

echo ============================================================
echo            PORTABLE DRIVE BABY SITTER - INSTALLER
echo ============================================================
echo.

set /p TARGET="Enter the drive letter to install to (example: I): "

:: Normalize input
set "TARGET=%TARGET: =%"
set "TARGET=%TARGET::=%"
set "TARGET=%TARGET:~0,1%"

echo.

:: Block installation to C:
if /I "%TARGET%"=="C" (
    echo [ERROR] Installation to C: is not allowed.
    pause
    exit /b 1
)

:: Validate drive exists
if not exist "%TARGET%:\" (
    echo [ERROR] Drive %TARGET%: does not exist.
    pause
    exit /b 1
)

echo Installing Drive Baby Sitter to %TARGET%:\Integrity_Check ...
echo.

:: Create folder structure
mkdir "%TARGET%:\Integrity_Check" >nul 2>&1

:: Copy all program files
xcopy /E /I /Y "%~dp0files" "%TARGET%:\Integrity_Check" >nul

:: Store the filename with literal !
set "ROOTFILE=!VERIFY_INTEGRITY.BAT"

:: Move the file from integrity_check to the root
move "%TARGET%:\Integrity_Check\%ROOTFILE%" "%TARGET%:\" >nul

echo Installation complete.
echo Files installed to: %TARGET%:\Integrity_Check
echo Root tool installed to: %TARGET%:\!VERIFY_INTEGRITY.BAT
echo.

:: Ask user if they want to run the program now
set /p RUNNOW="Run Drive Baby Sitter now? (Y/N): "

if /I "%RUNNOW%"=="Y" (
    echo.
    echo Launching Drive Baby Sitter...
    echo.
    call "%TARGET%:\%ROOTFILE%"
)

echo.
pause