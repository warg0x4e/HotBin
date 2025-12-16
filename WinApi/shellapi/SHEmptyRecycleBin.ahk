#Requires AutoHotkey v2.0+

SHEmptyRecycleBin(hWnd, szRootPath, dwFlags)
{
    hr := DllCall("shell32\SHEmptyRecycleBinW", "Ptr", hWnd, "WStr", szRootPath, "UInt", dwFlags, "Int")
    
    if hr < 0
        throw OSError(hr, -1)
}
