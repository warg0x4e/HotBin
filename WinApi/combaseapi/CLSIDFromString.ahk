#Requires AutoHotkey v2.0+

CLSIDFromString(lpsz, pclsid)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-clsidfromstring
    
    DllCall("ole32\CLSIDFromString"
           ,"WStr", lpsz
           ,"Ptr", pclsid
           ,"HRESULT")
    
    return pclsid
}
