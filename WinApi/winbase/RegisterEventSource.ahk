#Requires AutoHotkey v2.0+

RegisterEventSource(lpUNCServerName, lpSourceName)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-registereventsourcew
    
    if HANDLE := DllCall("advapi32\RegisterEventSourceW"
                        ,"WStr", lpUNCServerName
                        ,"WStr", lpSourceName
                        ,"Ptr")
        
        return HANDLE
        
    throw OSError(A_LastError, A_ThisFunc, HANDLE)
}
