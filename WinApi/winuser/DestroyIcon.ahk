#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk

DestroyIcon(hIcon)
{
    if !DllCall("user32\DestroyIcon", "Ptr", hIcon, "Int")
        throw OSError(A_LastError, HERE)
}
