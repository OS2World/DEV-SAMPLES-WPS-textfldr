# Makefile.wat - Open Watcom makefile for textfldr.dll
#
# Build with:  wmake -f Makefile.wat
# Or use:      mk.cmd

SOMINC = C:\os2tk45\som\include
WPSINC = C:\os2tk45\h

SOMDLL  = C:\OS2\DLL\som.dll
SOMLIB  = release\som.lib
PMWPDLL = C:\OS2\DLL\pmwp.dll
PMWPLIB = release\pmwp.lib

CC    = wcc386
LINK  = wlink
RC    = wrc
WLIB  = wlib

# -bd:      build as DLL
# -bt=os2:  target OS/2 32-bit
# -zq:      quiet
# -wx:      all warnings
# -wcd=726:  suppress W726 "unused formal parameter" in SOM toolkit headers
# -wcd=136:  suppress W136 "conversion between different pointer types"
# -wcd=1177: suppress W1177 "Modifier repeated in declaration" in sombtype.h
# -d1:       line-number debug info
CFLAGS = -bd -bt=os2 -zq -wx -wcd=726 -wcd=136 -wcd=1177 -d1
INCL   = -Ih -Isrc -I$(SOMINC) -I$(WPSINC)

# Function exports: SOMLINK = _System, no underscore prefix
# Data exports: wcc386 32-bit flat model does not add _ prefix to C data symbols
EXPS = &
    EXP TextFolderNewClass &
    EXP M_TextFolderNewClass &
    EXP TextFolderClassData &
    EXP TextFolderCClassData &
    EXP M_TextFolderClassData &
    EXP M_TextFolderCClassData

LFLAGS = SYSTEM OS2V2_DLL &
         NAME release\textfldr.dll &
         OP MAP=release\textfldr.map &
         @src\textfldr.def &
         LIBF $(SOMLIB),$(PMWPLIB) &
         $(EXPS)

OBJS    = release\textfldr.obj
OBJLIST = release\textfldr.obj

all : release\textfldr.dll .SYMBOLIC

release\textfldr.dll : $(OBJS) release\textfldr.res $(SOMLIB) $(PMWPLIB)
	$(LINK) $(LFLAGS) FIL $(OBJLIST)
	$(RC) release\textfldr.res $@

release\textfldr.obj : src\textfldr.c h\textfldr.ih h\textfldr.h
	$(CC) $(CFLAGS) $(INCL) src\textfldr.c -fo=$@

release\textfldr.res : src\textfldr.rc src\textfldrres.h src\textfldr.ico
	$(RC) -r -i=src -i=h -i=$(SOMINC) -i=$(WPSINC) src\textfldr.rc
	copy src\textfldr.res release
	del src\textfldr.res

release\som.lib : $(SOMDLL)
	$(WLIB) -n -b -q $@ +$(SOMDLL)

release\pmwp.lib : $(PMWPDLL)
	$(WLIB) -n -b -q $@ +$(PMWPDLL)

clean : .SYMBOLIC
	@if exist release\*.obj del release\*.obj
	@if exist release\*.res del release\*.res
	@if exist release\*.lib del release\*.lib
	@if exist release\*.dll del release\*.dll
	@if exist release\*.map del release\*.map
	@if exist release\*.err del release\*.err
