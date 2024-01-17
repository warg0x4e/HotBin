#Requires AutoHotkey v2.0+

StrFormatByteSize(qdw)
{
    ;// https://tinyurl.com/shlwapi-strformatbytesizew
    
    if PWSTR := DllCall("shlwapi\StrFormatByteSizeW"
                       ,"Int64", qdw
                       ,"Ptr", buf := Buffer(40)
                       ,"UInt", buf.Size >> 1
                       ,"WStr")
        return PWSTR
        
    throw Error(PWSTR, A_ThisFunc, A_LastError)
}
