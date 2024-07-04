#Requires AutoHotkey v2.0+

DestroyIcon(hIcon)
{
    ;// https://bit.ly/4cJ5bx3
    
    if !DllCall("user32\DestroyIcon"
               ,"Ptr", hIcon
               ,"Int")
        
        throw OSError(A_LastError)
}
