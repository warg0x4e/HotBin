#Requires AutoHotkey v2.0+

ReportEvent(hEventLog, wType, wCategory, dwEventID, lpUserSid, wNumStrings, dwDataSize, lpStrings, lpRawData)
{
    ;// https://bit.ly/3VKQKBQ
    
    if !DllCall("advapi32\ReportEventW"
               ,"Ptr", hEventLog
               ,"UShort", wType
               ,"UShort", wCategory
               ,"UInt", dwEventID
               ,"Ptr", lpUserSid
               ,"UShort", wNumStrings
               ,"UInt", dwDataSize
               ,"Ptr", lpStrings
               ,"Ptr", lpRawData
               ,"Int")
        
        throw OSError(A_LastError)
}
