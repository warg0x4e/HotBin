#Requires AutoHotkey v2.0+

VerSetConditionMask(dwlConditionMask, dwTypeMask, wCondition)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnt/nf-winnt-versetconditionmask
    
    return DllCall("kernel32\VerSetConditionMask"
                  ,"Int64", dwlConditionMask
                  ,"UInt", dwTypeMask
                  ,"UChar", wCondition
                  ,"Int64")
}
