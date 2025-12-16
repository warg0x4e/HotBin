#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include winerror\FAILED.ahk

SHEmptyRecycleBin(hWnd, szRootPath, dwFlags)
{
    hr := DllCall("shell32\SHEmptyRecycleBinW", "Ptr", hWnd, "WStr", szRootPath, "UInt", dwFlags, "Int")
    
    if FAILED(hr)
        throw OSError(hr, HERE)
}
