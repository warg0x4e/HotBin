#Requires AutoHotkey v2.0+

LoadString(hInstance, uID)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-loadstringw
    
    if int := DllCall("user32\LoadStringW"
                     ,"Ptr", hInstance
                     ,"UInt", uID
                     ,"PtrP", &(lpBuffer := 0)
                     ,"Int", 0
                     ,"Int")
        
        return StrGet(lpBuffer, int)
        
    throw Error(int, A_ThisFunc, A_LastError)
}
