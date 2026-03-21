REM  make32.bat -  Batch file for assembling/linking 32-bit Assembly programs
REM  Revised: 11/15/01

@echo off
cls

REM The following three lines can be customized for your system:
REM ********************************************BEGIN customize
SET PATH=C:\Users\17169\Documents\MyWork\fzucourses\Majorcourse\2502-fzu-AsmProgram-HongrenHuang\Materials\teaching\fzuasm\bin
SET INCLUDE=C:\Users\17169\Documents\MyWork\fzucourses\Majorcourse\2502-fzu-AsmProgram-HongrenHuang\Materials\teaching\fzuasm\include
SET LIB=C:\Users\17169\Documents\MyWork\fzucourses\Majorcourse\2502-fzu-AsmProgram-HongrenHuang\Materials\teaching\fzuasm\lib
REM ********************************************END customize

ML -Zi -c -Fl -coff %1.asm
if errorlevel 1 goto terminate

REM add the /MAP option for a map file in the link command.

LINK32 %1.obj irvine32.lib kernel32.lib /SUBSYSTEM:CONSOLE /DEBUG
if errorLevel 1 goto terminate

dir %1.*

:terminate
pause