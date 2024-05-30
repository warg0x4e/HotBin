#Requires AutoHotkey v2.0+

GetCommandLine()
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getcommandlinew
    
    return DllCall("kernel32\GetCommandLineW", "WStr")
}
