#Requires AutoHotkey v2.0+

SHGetStockIconInfo(siid, uFlags, psii)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shgetstockiconinfo
    
    return DllCall("shell32\SHGetStockIconInfo"
                  ,"UInt", siid
                  ,"UInt", uFlags
                  ,"Ptr", psii
                  ,"HRESULT")
}

#Include %A_ScriptDir%
#Include WinApi\shellapi\SHSTOCKICONINFO.ahk
