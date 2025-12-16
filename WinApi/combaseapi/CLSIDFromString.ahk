#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include guiddef\CLSID.ahk
#Include winerror\FAILED.ahk

CLSIDFromString(szCLSIDOrProgID, clsidInstance:=CLSID())
{
    hr := DllCall("ole32\CLSIDFromString", "WStr", szCLSIDOrProgID, "Ptr", clsidInstance, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
        
    return clsidInstance
}
