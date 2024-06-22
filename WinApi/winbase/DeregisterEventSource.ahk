#Requires AutoHotkey v2.0+

DeregisterEventSource(hEventLog)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-deregistereventsource
    
    if BOOL := DllCall("advapi32\DeregisterEventSource"
                      ,"Ptr", hEventLog
                      ,"Int")
        
        return BOOL
        
    throw OSError(A_LastError, A_ThisFunc, BOOL)
}
