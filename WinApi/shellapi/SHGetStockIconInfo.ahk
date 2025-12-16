#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include shellapi\SHSTOCKICONINFO.ahk
#Include winerror\FAILED.ahk

SHGetStockIconInfo(siid, dwFlags, shsiiInstance:=SHSTOCKICONINFO())
{
    hr := DllCall("shell32\SHGetStockIconInfo", "UInt", siid, "UInt", dwFlags, "Ptr", shsiiInstance, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
        
    return shsiiInstance
}
