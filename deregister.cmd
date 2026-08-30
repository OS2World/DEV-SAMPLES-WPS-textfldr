/* deregister.cmd - Deregister TextFolder WPS class */
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs

if SysDeregisterObjectClass('TextFolder') then
    say 'TextFolder deregistered successfully.'
else
    say 'ERROR: SysDeregisterObjectClass failed.'
