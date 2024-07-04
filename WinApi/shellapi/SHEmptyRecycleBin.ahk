#Requires AutoHotkey v2.0+

SHEmptyRecycleBin(hWnd, szRootPath, dwFlags)
{
    ;// https://bit.ly/4cDLeaM
    
    DllCall("shell32\SHEmptyRecycleBinW"
           ,"Ptr", hWnd
           ,"WStr", szRootPath
           ,"UInt", dwFlags
           ,"HRESULT")
}
