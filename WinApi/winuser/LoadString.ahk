#Requires AutoHotkey v2.0+

LoadString(hInstance, uID)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-loadstringw
    
    if cch := DllCall("user32\LoadStringW"
                     ,"Ptr", hInstance
                     ,"UInt", uID
                     ,"PtrP", &(lpBuffer := 0)
                     ,"Int", 0
                     ,"Int")
        
        return StrGet(lpBuffer, cch)
    
    throw Error(cch, A_ThisFunc)
}
