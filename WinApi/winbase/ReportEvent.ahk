#Requires AutoHotkey v2.0+

ReportEvent(hEventLog, wType, wCategory, dwEventID, lpUserSid, lpStrings, lpRawData)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-reporteventw
    
    if BOOL := DllCall("advapi32\ReportEventW"
                      ,"Ptr", hEventLog
                      ,"UShort", wType
                      ,"UShort", wCategory
                      ,"UInt", dwEventID
                      ,"Ptr", lpUserSid
                      ,"UShort", lpStrings is Buffer
                                 ? lpStrings.Size / A_PtrSize
                                 : 0
                      ,"UInt", lpRawData is Buffer
                               ? lpRawData.Size
                               : 0
                      ,"Ptr", lpStrings
                      ,"Ptr", lpRawData
                      ,"Int")
        
        return BOOL
        
    throw OSError(A_LastError, A_ThisFunc, BOOL)
}
