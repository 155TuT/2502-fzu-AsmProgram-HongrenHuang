@echo off
setlocal

if "%~1"=="" (
    echo Usage: run32 file.asm ^| file.exe
    exit /b 1
)

set "ARG=%~f1"

if not exist "%ARG%" (
    echo [ERROR] File not found: %~1
    exit /b 1
)

for %%F in ("%ARG%") do (
    set "DIR=%%~dpF"
    set "NAME=%%~nF"
    set "EXT=%%~xF"
)

pushd "%DIR%"

if /I "%EXT%"==".asm" (
    if not exist "%NAME%.exe" (
        echo [ERROR] Executable not found: "%DIR%%NAME%.exe"
        echo [HINT] Build it first with: teaching\fzuasm\make32.bat "%NAME%"
        popd
        exit /b 1
    )
    "%NAME%.exe"
) else if /I "%EXT%"==".exe" (
    "%NAME%.exe"
) else (
    echo [ERROR] Unsupported file type: %EXT%
    echo [HINT] Use .asm or .exe
    popd
    exit /b 1
)

set "RET=%ERRORLEVEL%"
popd
exit /b %RET%
