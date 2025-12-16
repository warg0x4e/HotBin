#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include guiddef\CLSID.ahk
#Include winerror\const\E_NOT_SUFFICIENT_BUFFER.ahk
#Include winerror\FAILED.ahk

CLSIDFromString(szCLSIDOrProgID, clsidInstance:=CLSID())
{
    if !(clsidInstance is Buffer) || clsidInstance.SIZE < CLSID.SIZE
        throw OSError(E_NOT_SUFFICIENT_BUFFER, HERE)
        
    hr := DllCall("ole32\CLSIDFromString", "WStr", szCLSIDOrProgID, "Ptr", clsidInstance, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
        
    return clsidInstance
}
