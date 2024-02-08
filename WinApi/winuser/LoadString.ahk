#Requires AutoHotkey v2.0+

LoadString(hInstance, uID)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-loadstringw
    
    if cchBufMax := DllCall("user32\LoadStringW"
                           ,"Ptr", hInstance
                           ,"UInt", uID
                           ,"PtrP", &(lpBuf := 0)
                           ,"Int", 0
                           ,"Int")
        
        return StrGet(lpBuf, cchBufMax)
    
    throw Error(A_LastError, A_ThisFunc, cchBufMax)
}
