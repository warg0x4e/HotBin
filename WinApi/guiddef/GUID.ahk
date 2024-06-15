#Requires AutoHotkey v2.0+

class GUID extends Buffer
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/guiddef/ns-guiddef-guid
    
    Data1
    {
        Get => NumGet(this, "UInt")
        Set => NumPut("UInt", value, this)
    }
    
    Data2
    {
        Get => NumGet(this, 4, "UShort")
        Set => NumPut("UShort", value, this, 4)
    }
    
    Data3
    {
        Get => NumGet(this, 6, "UShort")
        Set => NumPut("UShort", value, this, 6)
    }
    
    Data4
    {
        Get => NumGet(this, 8, "Int64")
        Set => NumPut("Int64", value, this, 8)
    }
    
    __New() => super.__New(16, 0)
}
