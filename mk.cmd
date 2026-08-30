@echo off
rem mk.cmd - Clean build of textfldr.dll using Open Watcom
rem Usage: mk.cmd [nobind]
rem   nobind  skip genbind.cmd (use existing h\textfldr.ih / h\textfldr.h)

if not exist release md release
set MK_LOG=release\mk.log

if "x%1"=="xnobind" goto skipbind
call genbind.cmd
:skipbind

echo ====== wmake clean ======
wmake -f Makefile.wat clean 2>&1 | tee %MK_LOG%

echo ====== wmake all ======
wmake -f Makefile.wat all 2>&1 | tee -a %MK_LOG%
