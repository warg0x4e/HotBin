#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk

LoadLibraryEx(szLibFileName, hFile, dwFlags)
{
    hLibModule := DllCall("kernel32\LoadLibraryExW", "WStr", szLibFileName, "Ptr", hFile, "UInt", dwFlags, "Ptr")
    
    if !hLibModule
        throw OSError(A_LastError, HERE)
        
    return hLibModule
}
