#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk

StrFormatByteSize(qdw)
{
    cchBuf := VarSetStrCapacity(&szBuf, 32)
    
    if !DllCall("shlwapi\StrFormatByteSizeW", "Int64", qdw, "WStr", szBuf, "UInt", cchBuf, "Ptr")
        throw OSError(A_LastError, HERE)
        
    return szBuf
}
