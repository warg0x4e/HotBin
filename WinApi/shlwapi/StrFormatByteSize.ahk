#Requires AutoHotkey v2.0+

StrFormatByteSize(qdw)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-strformatbytesizew
    
    if PWSTR := DllCall("shlwapi\StrFormatByteSizeW"
                       ,"Int64", qdw
                       ,"Ptr", Buffer(520)
                       ,"UInt", 260
                       ,"WStr")
    
        return PWSTR
        
    throw Error(PWSTR, A_ThisFunc)
}
