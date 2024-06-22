#Requires AutoHotkey v2.0+

IsWindowsVersionOrGreater(wMajorVersion, wMinorVersion, wServicePackMajor)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/versionhelpers/nf-versionhelpers-iswindowsversionorgreater
    
    VER_GREATER_EQUAL := 3
    
    VER_MAJORVERSION := 0x2
    VER_MINORVERSION := 0x1
    VER_SERVICEPACKMAJOR := 0x20
    
    osvi := OSVERSIONINFOEX()
    dwlConditionMask := 0
    
    osvi.dwMajorVersion := wMajorVersion
    osvi.dwMinorVersion := wMinorVersion
    osvi.wServicePackMajor := wServicePackMajor
    
    VER_SET_CONDITION(&dwlConditionMask, VER_MAJORVERSION, VER_GREATER_EQUAL)
    VER_SET_CONDITION(&dwlConditionMask, VER_MINORVERSION, VER_GREATER_EQUAL)
    VER_SET_CONDITION(&dwlConditionMask, VER_SERVICEPACKMAJOR, VER_GREATER_EQUAL)
    
    return VerifyVersionInfo(osvi
                            ,VER_MAJORVERSION |
                             VER_MINORVERSION |
                             VER_SERVICEPACKMAJOR
                            ,dwlConditionMask)
}

#Include %A_LineFile%\..\..
#Include winbase\VerifyVersionInfo.ahk
#Include winnt\OSVERSIONINFOEX.ahk
#Include winnt\VER_SET_CONDITION.ahk
