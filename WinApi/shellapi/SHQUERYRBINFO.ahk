#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include winerror\const\E_ACCESSDENIED.ahk

class SHQUERYRBINFO Extends Buffer
{
    static SIZE => A_PtrSize + 16
    
    SIZE
    {
        Set
        {
            throw OSError(E_ACCESSDENIED, HERE)
        }
    }
    
    i64Size     => NumGet(this, A_PtrSize    , "Int64")
    i64NumItems => NumGet(this, A_PtrSize + 8, "Int64")
    
    __New()
    {
        cbSize := SHQUERYRBINFO.SIZE
        super.__New(cbSize, 0)
        NumPut("UInt", cbSize, this, 0)
    }
}
