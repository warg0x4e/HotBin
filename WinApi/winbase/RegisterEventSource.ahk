#Requires AutoHotkey v2.0+

RegisterEventSource(szUNCServerName, szSourceName)
{
    ;// https://bit.ly/3XL3gnB
    
    if hEventLog := DllCall("advapi32\RegisterEventSourceW"
                           ,"WStr", szUNCServerName
                           ,"WStr", szSourceName
                           ,"Ptr")
        
        return hEventLog
        
    throw OSError(A_LastError)
}
