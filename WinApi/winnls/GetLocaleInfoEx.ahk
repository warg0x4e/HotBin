#Requires AutoHotkey v2.0+

GetLocaleInfoEx(lpLocaleName, LCType)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getlocaleinfoex
    
    if !cchData := DllCall("kernel32\GetLocaleInfoEx"
                          ,lpLocaleName is Integer ? "Ptr" : "WStr", lpLocaleName
                          ,"UInt", LCType
                          ,"Ptr", 0
                          ,"Int", 0
                          ,"Int")
        
        throw Error(cchData, A_ThisFunc)
    
    if !cchData := DllCall("kernel32\GetLocaleInfoEx"
                          ,lpLocaleName is Integer ? "Ptr" : "WStr", lpLocaleName
                          ,"UInt", LCType
                          ,"Ptr", lpLCData := Buffer(cchData << 1, 0)
                          ,"Int", cchData
                          ,"Int")
        
        throw Error(cchData, A_ThisFunc)
    
    return StrGet(lpLCData, cchData, "UTF-16")
}
