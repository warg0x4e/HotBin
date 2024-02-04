#Requires AutoHotkey v2.0+

LoadLibrary(lpLibFileName)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibraryw
    
    if HMODULE := DllCall("kernel32\LoadLibraryW"
                         ,lpLibFileName is Integer ? "Ptr" : "WStr", lpLibFileName
                         ,"Ptr")
        
        return HMODULE
    
    throw OSError(A_LastError, A_ThisFunc, HMODULE)
}
