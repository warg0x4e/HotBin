#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include const\NULL.ahk
#Include combaseapi\CoTaskMemFree.ahk
#Include guiddef\CLSID.ahk
#Include winerror\const\E_NOT_SUFFICIENT_BUFFER.ahk
#Include winerror\FAILED.ahk

StringFromCLSID(clsidInstance)
{
    if !(clsidInstance is Buffer) || clsidInstance.SIZE < CLSID.SIZE
        throw OSError(E_NOT_SUFFICIENT_BUFFER, HERE)
        
    pszCLSID := NULL
    hr := DllCall("ole32\StringFromCLSID", "Ptr", clsidInstance, "PtrP", &pszCLSID, "Int")
    
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
