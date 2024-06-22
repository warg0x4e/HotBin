#Requires AutoHotkey v2.0+

SHGetStockIconInfo(siid, uFlags, psii)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shgetstockiconinfo
    
    if HRESULT := DllCall("shell32\SHGetStockIconInfo"
                         ,"UInt", siid
                         ,"UInt", uFlags
                         ,"Ptr", psii
                         ,"Int")
        
        throw OSError(A_LastError, A_ThisFunc, HRESULT)
        
    return HRESULT
}
