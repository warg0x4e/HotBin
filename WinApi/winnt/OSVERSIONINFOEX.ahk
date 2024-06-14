#Requires AutoHotkey v2.0+

class OSVERSIONINFOEX extends Buffer
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-osversioninfow
    
    dwMajorVersion
    {
        Get => NumGet(this, 4, "UInt")
        Set => NumPut("UInt", value, this, 4)
    }
    
    dwMinorVersion
    {
        Get => NumGet(this, 8, "UInt")
        Set => NumPut("UInt", value, this, 8)
    }
    
    dwBuildNumber
    {
        Get => NumGet(this, 12, "UInt")
        Set => NumPut("UInt", value, this, 12)
    }
    
    dwPlatformId
    {
        Get => NumGet(this, 16, "UInt")
        Set => NumPut("UInt", value, this, 16)
    }
    
    szCSDVersion
    {
        Get => StrGet(this.Ptr + 20, 128, "UTF-16")
        Set => StrPut(value, this.Ptr + 20, 128, "UTF-16")
    }
    
    wServicePackMajor
    {
        Get => NumGet(this, 276, "UShort")
        Set => NumPut("UShort", value, this, 276)
    }
    
    wServicePackMinor
    {
        Get => NumGet(this, 278, "UShort")
        Set => NumPut("UShort", value, this, 278)
    }
    
    wSuiteMask
    {
        Get => NumGet(this, 280, "UShort")
        Set => NumPut("UShort", value, this, 280)
    }
    
    wProductType
    {
        Get => NumGet(this, 282, "UChar")
        Set => NumPut("UChar", value, this, 282)
    }
    
    __New()
    {
        cbSize := 284
        super.__New(cbSize, 0)
        NumPut("UInt", cbSize, this)
    }
}
