#Requires AutoHotkey v2.0+

GetLocaleInfoEx(lpLocaleName, LCType)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnls/nf-winnls-getlocaleinfoex
    
    if int := DllCall("kernel32\GetLocaleInfoEx"
                     ,lpLocaleName is Integer ? "Ptr" : "WStr", lpLocaleName
                     ,"UInt", LCType
                     ,"Ptr", lpLCData := Buffer(520)
                     ,"Int", 260
                     ,"Int")
        
        return LCType & 0x20000000
               ? NumGet(lpLCData, "UInt")
               : StrGet(lpLCData, int)
        
    throw Error(int, A_ThisFunc, A_LastError)
}
