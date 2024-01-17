#Requires AutoHotkey v2.0+

LoadString(hInstance, uID)
{
    ;// https://tinyurl.com/winuser-loadstringw
    
    if int := DllCall("user32\LoadStringW"
                     ,"Ptr", hInstance
                     ,"UInt", uID
                     ,"PtrP", &(lpBuf := 0)
                     ,"Int", 0
                     ,"Int")
        return StrGet(lpBuf, int)
        
    throw Error(int, A_ThisFunc, A_LastError)
}
