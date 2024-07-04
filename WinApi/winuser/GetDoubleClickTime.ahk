#Requires AutoHotkey v2.0+

GetDoubleClickTime()
{
    ;// https://bit.ly/45P464o
    
    return DllCall("user32\GetDoubleClickTime"
                  ,"UInt")
}
