#Requires AutoHotkey v2.0+

class GUID extends Buffer
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/guiddef/ns-guiddef-guid
    
    ;// TBD
    
    __New() => super.__New(16, 0)
}
