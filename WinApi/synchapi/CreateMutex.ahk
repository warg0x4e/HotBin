#Requires AutoHotkey v2.0+

CreateMutex(lpMutexAttributes, bInitialOwner, szName)
{
    ;// https://bit.ly/3zprgm1
    
    if hMutex := DllCall("kernel32\CreateMutexW"
                        ,"Ptr", lpMutexAttributes
                        ,"Int", bInitialOwner
                        ,"WStr", szName
                        ,"Ptr")
        
        return hMutex
        
    throw OSError(A_LastError)
}
