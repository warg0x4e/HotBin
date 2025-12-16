#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk

StrFormatByteSize(qdw)
{
    cch := VarSetStrCapacity(&sz, 32)
    
    if !DllCall("shlwapi\StrFormatByteSizeW", "Int64", qdw, "WStr", sz, "UInt", cch, "Ptr")
        throw OSError(A_LastError, HERE)
        
    return sz
}
