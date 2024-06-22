#Requires AutoHotkey v2.0+

GetDoubleClickTime()
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getdoubleclicktime
    
    return DllCall("user32\GetDoubleClickTime", "UInt")
}
