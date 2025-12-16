#Requires AutoHotkey v2.0+

#Include ..
#Include minwinbase\FILETIME.ahk

GetSystemTimeAsFileTime(ftInstance:=FILETIME())
{
    DllCall("kernel32\GetSystemTimeAsFileTime", "Ptr", ftInstance)
    
    return ftInstance
}
