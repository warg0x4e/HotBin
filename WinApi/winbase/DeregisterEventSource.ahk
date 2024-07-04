#Requires AutoHotkey v2.0+

DeregisterEventSource(hEventLog)
{
    ;// https://bit.ly/3L6X41r
    
    if !DllCall("advapi32\DeregisterEventSource"
               ,"Ptr", hEventLog
               ,"Int")
        
        throw OSError(A_LastError)
}
