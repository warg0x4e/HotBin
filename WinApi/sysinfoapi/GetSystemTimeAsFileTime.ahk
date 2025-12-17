#Requires AutoHotkey v2.0+

#Include ..
#Include minwinbase\FILETIME.ahk

GetSystemTimeAsFileTime(bufFILETIME:=FILETIME())
{
    DllCall("kernel32\GetSystemTimeAsFileTime", "Ptr", bufFILETIME)
    
    return bufFILETIME
}
