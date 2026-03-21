@echo off
setlocal

if "%~1"=="" (
    echo Usage: build32 file.asm
    exit /b 1
)

for %%I in ("%~dp0..") do set "ASMROOT=%%~fI"
set "IRVINE=%ASMROOT%\third_party\Irvine"
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
set "SRC=%~f1"

if not exist "%SRC%" (
    echo [ERROR] Source file not found: %~1
    exit /b 1
)

if not exist "%IRVINE%\Irvine32.inc" (
    echo [ERROR] Irvine32.inc not found: %IRVINE%
    exit /b 1
)

if not exist "%VSWHERE%" (
    echo [ERROR] vswhere.exe not found.
    exit /b 1
)

for /f "usebackq delims=" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
    set "VSROOT=%%i"
)

if not defined VSROOT (
    echo [ERROR] Visual Studio C++ Build Tools not found.
    exit /b 1
)

call "%VSROOT%\Common7\Tools\VsDevCmd.bat" -arch=x86 >nul
if errorlevel 1 (
    echo [ERROR] Failed to initialize Visual Studio build environment.
    exit /b 1
)

for %%F in ("%SRC%") do (
    set "DIR=%%~dpF"
    set "NAME=%%~nF"
)

pushd "%DIR%"

ml /nologo /c /coff /I "%IRVINE%" "%NAME%.asm"
if errorlevel 1 (
    echo.
    echo [ERROR] Assembly failed.
    popd
    exit /b 1
)

link /nologo /subsystem:console /LIBPATH:"%IRVINE%" /out:"%NAME%.exe" "%NAME%.obj" Irvine32.lib Kernel32.lib User32.lib
if errorlevel 1 (
    echo.
    echo [ERROR] Linking failed.
    popd
    exit /b 1
)

echo.
echo [OK] Output: "%DIR%%NAME%.exe"

popd
endlocal