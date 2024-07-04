#Requires AutoHotkey v2.0+

StrFormatByteSize(qdw)
{
    ;// https://bit.ly/3W75PxV
    
    VarSetStrCapacity(&szBuf, 260)
    
    if DllCall("shlwapi\StrFormatByteSizeW"
              ,"Int64", qdw
              ,"WStr", szBuf
              ,"UInt", 260
              ,"Ptr")
        
        return szBuf
        
    throw OSError(A_LastError)
}
