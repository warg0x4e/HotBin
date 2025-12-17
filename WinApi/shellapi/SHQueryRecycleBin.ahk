#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include shellapi\SHQUERYRBINFO.ahk
#Include winerror\FAILED.ahk

SHQueryRecycleBin(szRootPath, bufSHQUERYRBINFO:=SHQUERYRBINFO())
{
    hr := DllCall("shell32\SHQueryRecycleBinW", "WStr", szRootPath, "Ptr", bufSHQUERYRBINFO, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
        
    return bufSHQUERYRBINFO
}
