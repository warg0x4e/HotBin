#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk

CreateMutex(saInstance, bInitialOwner, szName)
{
    hMutex := DllCall("kernel32\CreateMutexW", "Ptr", saInstance, "Int", bInitialOwner, "WStr", szName, "Ptr")
    
    if !hMutex
        throw OSError(A_LastError, HERE)
        
    return hMutex 
}
