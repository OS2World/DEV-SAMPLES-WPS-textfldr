# textfldr — WPS Text Folder Sample (C SOM), Open Watcom Port

OS/2 WorkPlace Shell sample demonstrating a custom `WPFolder` subclass
implemented in C with SOM 2.x. The folder accepts only plain-text files
on drag-and-drop; non-text objects are rejected. Tree view and Include
settings pages are removed from the settings notebook.

---

## Class Hierarchy

```
SOMObject
  └── WPObject
        └── WPFileSystem
              └── WPFolder
                    └── TextFolder          (metaclass: M_TextFolder)
```

---

## Directory Layout

```
textfldr/
├── idl/          textfldr.idl     — SOM 2.x IDL source
├── h/            textfldr.ih, textfldr.h  (sc-generated; created by genbind.cmd)
├── src/          textfldr.c, textfldr.rc, textfldrres.h, textfldr.def, textfldr.ico
├── doc/          (reserved — no IPF help file in this sample)
├── release/      build output (dll, obj, res, lib, map, log)
├── Makefile.wat  Open Watcom makefile
├── mk.cmd        one-shot clean build
├── genbind.cmd   runs sc to generate h\textfldr.ih and h\textfldr.h
├── register.cmd  REXX: SysRegisterObjectClass('TextFolder', ...)
└── deregister.cmd REXX: SysDeregisterObjectClass('TextFolder')
```

---

## Prerequisites

| Item | Path |
|---|---|
| Open Watcom 2.0 | `PATH` must include Watcom bin |
| OS/2 Toolkit 4.5 | `C:\os2tk45` |
| SOM runtime | `C:\OS2\DLL\som.dll` |
| PMWP (WPS shell) | `C:\OS2\DLL\pmwp.dll` |
| SOM compiler `sc` | on `PATH` (Toolkit) |

---

## Build

```
cd C:\Temporal\1.- OS2\SWtest\wps\textfldr

rem First time (or after editing textfldr.idl):
genbind.cmd

rem Then build:
wmake -f Makefile.wat
```

Or use the convenience wrapper which does both steps:

```
mk.cmd
```

Output: `release\textfldr.dll`

---

## Register / Test

```
register.cmd
```

Create a folder on the Desktop and set its class to `TextFolder` via
the WPS object settings, or create a new object using `WinCreateObject`.
Drag a plain-text `.txt` file onto it — it should be accepted.
Drag a binary file — it should be rejected.

```
deregister.cmd
```

---

## Porting Notes (IBM C/C++ → Open Watcom)

| Item | Status |
|---|---|
| `wcc386` replaces IBM `icc` for `textfldr.c` | Done — C project, not C++ |
| `sc -s"ih;h"` generates C bindings | `textfldr.ih` and `textfldr.h` moved to `h\` by `genbind.cmd` |
| `textfldr.rc` `#include "textfldr.ih"` replaced | `#include <os2.h>` + `#include "textfldrres.h"` — wrc cannot parse SOM headers |
| `src\textfldrres.h` created | Holds `ID_ICON 100` extracted from IDL `passthru C_ih` block |
| `OPTION CASEEXACT` in `.def` | Required for correct C symbol matching |
| `wlink FIL` directive | Single object file — no comma-separated list issue |
| Data symbol exports | Bare form `EXP TextFolderClassData` — wcc386 32-bit flat model does not prefix C data symbols with `_` |
| `_IsTextFile` / `_ValidateDragAndDrop` SOM dispatch macros | Replaced with direct `TextFolderwps_IsTextFile` / `TextFolderwps_ValidateDragAndDrop` calls — the SOM-generated `.ih` dispatches private methods through stubs (`_IsTextFile_`) that wlink cannot resolve; direct calls work since all call sites are in the same translation unit |
| W1177 in `sombtype.h` | Suppressed with `-wcd=1177` — "Modifier repeated in declaration" in the SOM toolkit header, not our code |
| `SOMInitModule` | Not needed; WPS calls `TextFolderNewClass` directly |

---

## Changelog

### 1.1 — 2026-08-29
- Open Watcom port: `Makefile.wat`, `mk.cmd`, `genbind.cmd`
- Files reorganized into `idl/`, `h/`, `src/`, `doc/`, `release/`
- Created `src/textfldrres.h` (resource constants for wrc)
- Created `src/textfldr.def` (BLDLEVEL)
- `src/textfldr.rc` updated: `#include <os2.h>` replaces `#include "textfldr.ih"`
- `src/textfldr.c`: replaced `_IsTextFile`/`_ValidateDragAndDrop` SOM dispatch macros with direct `TextFolderwps_*` calls
- Added `-wcd=1177` to suppress spurious warning in `sombtype.h`
- Added `register.cmd`, `deregister.cmd`, `.gitattributes`
- `release\textfldr.dll` builds and links cleanly
