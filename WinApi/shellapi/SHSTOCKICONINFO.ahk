#Requires AutoHotkey v2.0+

class SHSTOCKICONINFO extends Buffer
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ns-shellapi-shstockiconinfo
    
    hIcon
    {
        Get => NumGet(this, A_PtrSize, "Ptr")
        Set => NumPut("Ptr", value, this, A_PtrSize)
    }
    
    iSysImageIndex
    {
        Get => NumGet(this, A_PtrSize << 1, "Int")
        Set => NumPut("Int", value, this, A_PtrSize << 1)
    }
    
    iIcon
    {
        Get => NumGet(this, (A_PtrSize << 1) + 4, "Int")
        Set => NumPut("Int", value, this, (A_PtrSize << 1) + 4)
    }
    
    szPath
    {
        Get => StrGet(this.Ptr + (A_PtrSize << 1) + 8, 260, "UTF-16")
        Set => StrPut(value, this.Ptr + (A_PtrSize << 1) + 8, 260, "UTF-16")
    }
    
    __New()
    {
        cbSize := (A_PtrSize << 1) + 528
        super.__New(cbSize, 0)
        NumPut("UInt", cbSize, this)
    }
}
