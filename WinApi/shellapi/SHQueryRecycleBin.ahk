#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include shellapi\SHQUERYRBINFO.ahk
#Include winerror\const\E_NOT_SUFFICIENT_BUFFER.ahk
#Include winerror\FAILED.ahk

SHQueryRecycleBin(szRootPath, shqrbiInstance:=SHQUERYRBINFO())
{
    if !(shqrbiInstance is Buffer) || shqrbiInstance.SIZE < SHQUERYRBINFO.SIZE
        throw OSError(E_NOT_SUFFICIENT_BUFFER, HERE)
        
    hr := DllCall("shell32\SHQueryRecycleBinW", "WStr", szRootPath, "Ptr", shqrbiInstance, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
        
    return shqrbiInstance
}
