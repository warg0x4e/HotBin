#Requires AutoHotkey v2.0+

class SHQUERYRBINFO extends Buffer
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ns-shellapi-shqueryrbinfo
    
    i64Size => NumGet(this, A_PtrSize, "Int64")
    
    i64NumItems => NumGet(this, A_PtrSize + 8, "Int64")
    
    __New()
    {
        cbSize := A_PtrSize + 16
        super.__New(cbSize)
        NumPut("UInt", cbSize, this)
    }
}
