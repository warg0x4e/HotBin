#Requires AutoHotkey v2.0+

LoadLibrary(lpLibFileName)
{
    ;// https://tinyurl.com/libloaderapi-loadlibraryw
    
    if HMODULE := DllCall("kernel32\LoadLibraryW"
                         ,lpLibFileName is Integer ? "Ptr" : "WStr", lpLibFileName
                         ,"Ptr")
        return HMODULE
        
    throw Error(HMODULE, A_ThisFunc, A_LastError)
}
