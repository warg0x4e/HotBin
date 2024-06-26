#Requires AutoHotkey v2.0+

FreeLibrary(hLibModule)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-freelibrary
    
    if BOOL := DllCall("kernel32\FreeLibrary"
                      ,"Ptr", hLibModule
                      ,"Int")
        
        return BOOL
        
    throw OSError(A_LastError, A_ThisFunc, BOOL)
}
