#Requires AutoHotkey v2.0+

DestroyIcon(hIcon)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-destroyicon
    
    if BOOL := DllCall("user32\DestroyIcon"
                      ,"Ptr", hIcon
                      ,"Int")
        
        return BOOL
        
    throw OSError(A_LastError, A_ThisFunc, BOOL)
}
