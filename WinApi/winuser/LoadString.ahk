#Requires AutoHotkey v2.0+

LoadString(hInstance, uID)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-loadstringw
    
    if cchBufferMax := DllCall("user32\LoadStringW"
                              ,"Ptr", hInstance
                              ,"UInt", uID
                              ,"PtrP", &(lpBuffer := 0)
                              ,"Int", 0
                              ,"Int")
        
        return StrGet(lpBuffer, cchBufferMax, "UTF-16")
    
    throw Error(cchBufferMax, A_ThisFunc)
}
