REM  make32.bat -  Batch file for assembling/linking 32-bit Assembly programs
REM  Revised: 11/15/01

@echo off
setlocal
cls

set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

if exist "%SCRIPT_DIR%\.env.local" (
    for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%SCRIPT_DIR%\.env.local") do (
        if not "%%~A"=="" set "%%~A=%%~B"
    )
)

if not defined FZUASM_ROOT set "FZUASM_ROOT=%SCRIPT_DIR%"
if not defined FZUASM_BIN set "FZUASM_BIN=%FZUASM_ROOT%\bin"
if not defined FZUASM_INCLUDE set "FZUASM_INCLUDE=%FZUASM_ROOT%\INCLUDE"
if not defined FZUASM_LIB set "FZUASM_LIB=%FZUASM_ROOT%\LIB"

set "PATH=%FZUASM_BIN%;%PATH%"
set "INCLUDE=%FZUASM_INCLUDE%"
set "LIB=%FZUASM_LIB%"

ML -Zi -c -Fl -coff %1.asm
if errorlevel 1 goto terminate

REM add the /MAP option for a map file in the link command.

LINK32 %1.obj irvine32.lib kernel32.lib /SUBSYSTEM:CONSOLE /DEBUG
if errorLevel 1 goto terminate

dir %1.*

:terminate
pause
endlocal
