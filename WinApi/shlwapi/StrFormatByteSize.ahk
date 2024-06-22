#Requires AutoHotkey v2.0+

StrFormatByteSize(qdw)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-strformatbytesizew
    
    return DllCall("shlwapi\StrFormatByteSizeW"
                  ,"Int64", qdw
                  ,"Ptr", Buffer(520, 0)
                  ,"UInt", 260
                  ,"WStr")
}
