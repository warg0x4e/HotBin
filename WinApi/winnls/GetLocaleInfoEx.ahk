#Requires AutoHotkey v2.0+

GetLocaleInfoEx(lpLocaleName, dwLCType, lpLCData)
{
    ;// https://tinyurl.com/winnls-getlocaleinfoex
    
    if int := DllCall("kernel32\GetLocaleInfoEx"
                     ,lpLocaleName is Integer ? "Ptr" : "WStr", lpLocaleName
                     ,"UInt", dwLCType
                     ,"Ptr", lpLCData
                     ,"Int", lpLCData = 0 ? 0 : lpLCData.Size >> 1
                     ,"Int")
        return int
        
    throw Error(int, A_ThisFunc, A_LastError)
}
