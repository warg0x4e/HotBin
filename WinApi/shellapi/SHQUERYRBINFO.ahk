#Requires AutoHotkey v2.0+

class SHQUERYRBINFO extends Buffer
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ns-shellapi-shqueryrbinfo
    
    i64Size
    {
        Get => NumGet(this, A_PtrSize, "Int64")
        Set => NumPut("Int64", value, this, A_PtrSize)
    }
    
    i64NumItems
    {
        Get => NumGet(this, A_PtrSize + 8, "Int64")
        Set => NumPut("Int64", value, this, A_PtrSize + 8)
    }
    
    __New()
    {
        cbSize := A_PtrSize + 16
        super.__New(cbSize, 0)
        NumPut("UInt", cbSize, this)
    }
}
