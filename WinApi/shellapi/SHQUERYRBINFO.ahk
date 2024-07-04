#Requires AutoHotkey v2.0+

class SHQUERYRBINFO extends Buffer
{
    ;// https://bit.ly/3RUjerB
    
    i64Size => NumGet(this, A_PtrSize, "Int64")
    i64NumItems => NumGet(this, A_PtrSize + 8, "Int64")
    
    __New()
    {
        cbSize := A_PtrSize + 16
        super.__New(cbSize, 0)
        NumPut("UInt", cbSize, this)
    }
}
