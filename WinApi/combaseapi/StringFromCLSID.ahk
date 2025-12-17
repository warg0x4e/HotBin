#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include const\NULL.ahk
#Include combaseapi\CoTaskMemFree.ahk
#Include guiddef\CLSID.ahk
#Include winerror\FAILED.ahk

StringFromCLSID(bufCLSID)
{
    pszCLSID := NULL
    hr := DllCall("ole32\StringFromCLSID", "Ptr", bufCLSID, "PtrP", &pszCLSID, "Int")
    
    if FAILED(hr)
    {
        if pszCLSID
            CoTaskMemFree(pszCLSID)
            
        throw OSError(hr, HERE)
    }
    
    szCLSID := StrGet(pszCLSID)
    CoTaskMemFree(pszCLSID)
    
    return szCLSID
}
