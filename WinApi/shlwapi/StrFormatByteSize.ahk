#Requires AutoHotkey v2.0+

StrFormatByteSize(qdwSize)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-strformatbytesizew
    
    return DllCall("shlwapi\StrFormatByteSizeW"
                  ,"Int64", qdwSize
                  ,"Ptr", Buffer(520)
                  ,"UInt", 260
                  ,"WStr")
}
