#Requires AutoHotkey v2.0+

LoadLibrary(lpLibFileName)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-loadlibraryw
    
    if HMODULE := DllCall("kernel32\LoadLibraryW"
                         ,"WStr", lpLibFileName
                         ,"Ptr")
        
        return HMODULE
        
    throw Error(HMODULE, A_ThisFunc)
}
