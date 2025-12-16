#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include winerror\const\E_ACCESSDENIED.ahk

class SHSTOCKICONINFO Extends Buffer
{
    static SIZE => A_PtrSize * 2 + 528
    
    SIZE
    {
        Set
        {
            throw OSError(E_ACCESSDENIED, HERE)
        }
    }
    
    hIcon          => NumGet(this     , A_PtrSize        , "Ptr")
    iSysImageIndex => NumGet(this     , A_PtrSize * 2    , "Int")
    iIcon          => NumGet(this     , A_PtrSize * 2 + 4, "Int")
    szPath         => StrGet(this.Ptr + A_PtrSize * 2 + 8       )
    
    __New()
    {
        cbSize := SHSTOCKICONINFO.SIZE
        super.__New(cbSize, 0)
        NumPut("UInt", cbSize, this, 0)
    }
}
