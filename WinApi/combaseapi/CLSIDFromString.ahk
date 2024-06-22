#Requires AutoHotkey v2.0+

CLSIDFromString(lpsz, pclsid)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-clsidfromstring
    
    if HRESULT := DllCall("ole32\CLSIDFromString"
                         ,"WStr", lpsz
                         ,"Ptr", pclsid
                         ,"Int")
        
        throw OSError(A_LastError, A_ThisFunc, HRESULT)
        
    return pclsid
}
