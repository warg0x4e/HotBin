#Requires AutoHotkey v2.0+

VER_SET_CONDITION(&dwlConditionMask, dwTypeMask, wCondition)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnt/nf-winnt-ver_set_condition
    
    dwlConditionMask := VerSetConditionMask(dwlConditionMask
                                           ,dwTypeMask
                                           ,wCondition)
}

#Include %A_LineFile%\..\..
#Include winnt\VerSetConditionMask.ahk
