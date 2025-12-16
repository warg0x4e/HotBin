#Requires AutoHotkey v2.0+

#Include ..
#Include combaseapi\CoTaskMemFree.ahk

StringFromCLSID(clsidInstance)
{
    pszCLSID := 0
    hr := DllCall("ole32\StringFromCLSID", "Ptr", clsidInstance, "PtrP", &pszCLSID, "Int")
    
    if hr < 0
    {
        if pszCLSID
            CoTaskMemFree(pszCLSID)
            
        throw OSError(hr, -1)
    }
    
    szCLSID := StrGet(pszCLSID)
    CoTaskMemFree(pszCLSID)
    
    return szCLSID
}
