#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include const\NULL.ahk

LoadString(hInstance, dwID)
{
    pszBuf := NULL
    cchBuf := DllCall("user32\LoadStringW", "Ptr", hInstance, "UInt", uID, "PtrP", &pszBuf, "Int", 0, "Int")
    
    if !cchBuf
        throw OSError(A_LastError, HERE)
        
    return StrGet(pszBuf, cchBuf)
}
