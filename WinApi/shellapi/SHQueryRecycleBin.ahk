#Requires AutoHotkey v2.0+

SHQueryRecycleBin(szRootPath, shqrbi)
{
    ;// https://bit.ly/3W2WGYd
    
    DllCall("shell32\SHQueryRecycleBinW"
           ,"WStr", szRootPath
           ,"Ptr", shqrbi
           ,"HRESULT")
}
