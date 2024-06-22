#Requires AutoHotkey v2.0+

GetLocaleInfoEx(lpLocaleName, LCType)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getlocaleinfoex
    
    if !cchData := DllCall("kernel32\GetLocaleInfoEx"
                          ,lpLocaleName == 0 ? "Ptr" : "WStr", lpLocaleName
                          ,"UInt", LCType
                          ,"Ptr", 0
                          ,"Int", 0
                          ,"Int")
        
        throw OSError(A_LastError, A_ThisFunc, cchData)
        
    if !cchData := DllCall("kernel32\GetLocaleInfoEx"
                          ,lpLocaleName == 0 ? "Ptr" : "WStr", lpLocaleName
                          ,"UInt", LCType
                          ,"Ptr", lpLCData := Buffer(cchData << 1, 0)
                          ,"Int", cchData
                          ,"Int")
        
        throw OSError(A_LastError, A_ThisFunc, cchData)
        
    return StrGet(lpLCData, cchData, "UTF-16")
}
