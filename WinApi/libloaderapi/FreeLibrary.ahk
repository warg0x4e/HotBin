#Requires AutoHotkey v2.0+

FreeLibrary(hLibModule)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-freelibrary
    
    if BOOL := DllCall("kernel32\FreeLibrary"
                      ,"Ptr", hLibModule
                      ,"Int")
        
        return BOOL
    
    throw Error(hLibModule, A_ThisFunc)
}
