#Requires AutoHotkey v2.0+

CreateMutex(lpMutexAttributes, bInitialOwner, lpName)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/synchapi/nf-synchapi-createmutexw
    
    if HANDLE := DllCall("kernel32\CreateMutexW"
                        ,"Ptr", lpMutexAttributes
                        ,"Int", bInitialOwner
                        ,"WStr", lpName
                        ,"Ptr")
        
        return HANDLE
        
    throw OSError(A_LastError, A_ThisFunc, HANDLE)
}
