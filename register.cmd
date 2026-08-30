/* register.cmd - Register TextFolder WPS class */
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs

parse source . . me
dll = filespec('drive', me) || filespec('path', me) || 'release\textfldr.dll'

if SysRegisterObjectClass('TextFolder', dll) then
    say 'TextFolder registered successfully.'
else
    say 'ERROR: SysRegisterObjectClass failed.'
