CreateMutex(lpMutexAttributes, bInitialOwner, lpName)
{
    ;// https://tinyurl.com/synchapi-createmutexw
    
    if HANDLE := DllCall("kernel32\CreateMutexW"
                        ,"Ptr", lpMutexAttributes
                        ,"Int", bInitialOwner
                        ,lpName is Integer ? "Ptr" : "WStr", lpName
                        ,"Ptr")
        return HANDLE
        
    throw Error(HANDLE, A_ThisFunc, A_LastError)
}
