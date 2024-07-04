#Requires AutoHotkey v2.0+

class SHSTOCKICONINFO extends Buffer
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ns-shellapi-shstockiconinfo
    
    hIcon => NumGet(this, A_PtrSize, "Ptr")
    iSysImageIndex => NumGet(this, A_PtrSize * 2, "Int")
    iIcon => NumGet(this, A_PtrSize * 2 + 4, "Int")
    szPath => StrGet(this.Ptr + A_PtrSize * 2 + 8)
    
    __New()
    {
        cbSize := A_PtrSize * 2 + 528
        super.__New(cbSize, 0)
        NumPut("UInt", cbSize, this)
    }
}
