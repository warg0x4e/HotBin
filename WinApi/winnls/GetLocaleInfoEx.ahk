#Requires AutoHotkey v2.0+

GetLocaleInfoEx(lpLocaleName, LCType)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getlocaleinfoex
    
    if !cch := DllCall("kernel32\GetLocaleInfoEx"
                      ,lpLocaleName = 0 ? "Ptr" : "WStr", lpLocaleName
                      ,"UInt", LCType
                      ,"Ptr", 0
                      ,"Int", 0
                      ,"Int")
        
        throw Error(cch, A_ThisFunc)
    
    if !cch := DllCall("kernel32\GetLocaleInfoEx"
                      ,lpLocaleName = 0 ? "Ptr" : "WStr", lpLocaleName
                      ,"UInt", LCType
                      ,"Ptr", lpLCData := Buffer(cch << 1)
                      ,"Int", cch
                      ,"Int")
        
        throw Error(cch, A_ThisFunc)
    
    return LCType & 0x20000000 ? NumGet(lpLCData, "UInt") : StrGet(lpLCData)
}
