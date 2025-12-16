#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include shellapi\SHSTOCKICONINFO.ahk
#Include winerror\const\E_NOT_SUFFICIENT_BUFFER.ahk
#Include winerror\FAILED.ahk

SHGetStockIconInfo(siid, dwFlags, shsiiInstance:=SHSTOCKICONINFO())
{
    if !(shsiiInstance is Buffer) || shsiiInstance.SIZE < SHSTOCKICONINFO.SIZE
        throw OSError(E_NOT_SUFFICIENT_BUFFER, HERE)
        
    hr := DllCall("shell32\SHGetStockIconInfo", "UInt", siid, "UInt", dwFlags, "Ptr", shsiiInstance, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
        
    return shsiiInstance
}
