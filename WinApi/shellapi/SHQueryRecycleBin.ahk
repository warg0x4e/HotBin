#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include shellapi\SHQUERYRBINFO.ahk
#Include winerror\FAILED.ahk

SHQueryRecycleBin(szRootPath, shqrbiInstance:=SHQUERYRBINFO())
{
    hr := DllCall("shell32\SHQueryRecycleBinW", "WStr", szRootPath, "Ptr", shqrbiInstance, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
        
    return shqrbiInstance
}
