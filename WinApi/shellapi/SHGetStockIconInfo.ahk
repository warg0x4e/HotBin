#Requires AutoHotkey v2.0+

SHGetStockIconInfo(siid, uFlags, shsii)
{
    ;// https://bit.ly/4eOoczV
    
    DllCall("shell32\SHGetStockIconInfo"
           ,"UInt", siid
           ,"UInt", uFlags
           ,"Ptr", shsii
           ,"HRESULT")
}
