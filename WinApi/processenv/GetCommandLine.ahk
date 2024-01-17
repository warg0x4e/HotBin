#Requires AutoHotkey v2.0+

GetCommandLine()
{
    return DllCall("kernel32\GetCommandLineW", "WStr")
}
