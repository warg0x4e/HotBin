#Requires AutoHotkey v2.0+

SHEmptyRecycleBin(hWnd, pszRootPath, dwFlags)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shemptyrecyclebinw
    
    if HRESULT := DllCall("shell32\SHEmptyRecycleBinW"
                         ,"Ptr", hWnd
                         ,"WStr", pszRootPath
                         ,"UInt", dwFlags
                         ,"Int")
        
        throw OSError(A_LastError, A_ThisFunc, HRESULT)
        
    return HRESULT
}
