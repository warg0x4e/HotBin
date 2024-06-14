#Requires AutoHotkey v2.0+

VerSetConditionMask(ConditionMask, TypeMask, Condition)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnt/nf-winnt-versetconditionmask
    
    return DllCall("kernel32\VerSetConditionMask"
                  ,"Int64", ConditionMask
                  ,"UInt", TypeMask
                  ,"UChar", Condition
                  ,"Int64")
}
