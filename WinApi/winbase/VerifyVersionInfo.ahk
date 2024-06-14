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
        
    if A_LastError = 1150
        return BOOL
    
    throw Error(BOOL, A_ThisFunc)
}
