#Requires AutoHotkey v2.0+

#Include ..
#Include guiddef\CLSID.ahk

CLSIDFromString(szCLSIDOrProgID, clsidInstance:=CLSID())
{
    hr := DllCall("ole32\CLSIDFromString", "WStr", szCLSIDOrProgID, "Ptr", clsidInstance, "Int")
    
    if hr < 0
        throw OSError(hr, -1)
        
    return clsidInstance
}
