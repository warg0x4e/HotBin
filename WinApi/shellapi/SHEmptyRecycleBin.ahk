#Requires AutoHotkey v2.0+

SHEmptyRecycleBin(hWnd, pszRootPath, dwFlags)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shemptyrecyclebinw
    
    if SHSTDAPI := DllCall("shell32\SHEmptyRecycleBinW"
                          ,"Ptr", hWnd
                          ,pszRootPath is Integer ? "Ptr" : "WStr", pszRootPath
                          ,"UInt", dwFlags
                          ,"Int")
        
        throw Error(SHSTDAPI, A_ThisFunc, A_LastError)
        
    return SHSTDAPI
}
