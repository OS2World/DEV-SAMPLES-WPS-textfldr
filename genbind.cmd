@echo off
rem genbind.cmd - Run SOM compiler to generate C bindings for textfldr.idl
rem Output: h\textfldr.ih  h\textfldr.h

if not exist release md release
set LOGFILE=release\genbind.log

echo Running sc to generate textfldr.ih and textfldr.h ... | tee -a %LOGFILE%

sc -s"ih;h" idl\textfldr.idl >> %LOGFILE% 2>>&1

if not exist idl\textfldr.ih goto noIh
move idl\textfldr.ih h\textfldr.ih >> %LOGFILE%
:noIh
if not exist idl\textfldr.h goto noH
move idl\textfldr.h h\textfldr.h >> %LOGFILE%
:noH

echo . | tee -a %LOGFILE%
