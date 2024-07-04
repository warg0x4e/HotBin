#Requires AutoHotkey v2.0+

SHGetKnownFolderPath(szfid, dwFlags, hToken)
{
    ;// https://bit.ly/4cMvu5D
    
    DllCall("ole32\CLSIDFromString"
           ,"WStr", szfid
           ,"Ptr", rfid := Buffer(16)
           ,"HRESULT")
    
    try
        DllCall("shell32\SHGetKnownFolderPath"
               ,"Ptr", rfid
               ,"UInt", dwFlags
               ,"Ptr", hToken
               ,"PtrP", &(ppszPath := 0)
               ,"HRESULT")
    catch Any as err
        throw err
    else
        return StrGet(ppszPath)
    finally
        DllCall("ole32\CoTaskMemFree"
               ,"Ptr", ppszPath)
}
