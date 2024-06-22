#Requires AutoHotkey v2.0+

IsWindows8OrGreater()
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/versionhelpers/nf-versionhelpers-iswindows8orgreater
    
    return IsWindowsVersionOrGreater(6, 2, 0)
}

#Include %A_LineFile%\..\..
#Include versionhelpers\IsWindowsVersionOrGreater.ahk
