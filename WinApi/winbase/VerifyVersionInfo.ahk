#Requires AutoHotkey v2.0+

VerifyVersionInfo(lpVersionInformation, dwTypeMask, dwlConditionMask)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-verifyversioninfow
    
    if BOOL := DllCall("kernel32\VerifyVersionInfoW"
                      ,"Ptr", lpVersionInformation
                      ,"UInt", dwTypeMask
                      ,"Int64", dwlConditionMask
                      ,"Int")
        
        return BOOL
        
    if A_LastError == ERROR_OLD_WIN_VERSION := 1150
        return BOOL
        
    throw OSError(A_LastError, A_ThisFunc, BOOL)
}
