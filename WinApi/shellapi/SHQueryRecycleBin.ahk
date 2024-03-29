#Requires AutoHotkey v2.0+

SHQueryRecycleBin(pszRootPath, pSHQueryRBInfo)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shqueryrecyclebinw
    
    if HRESULT := DllCall("shell32\SHQueryRecycleBin"
                         ,pszRootPath is Integer ? "Ptr" : "WStr", pszRootPath
                         ,"Ptr", pSHQueryRBInfo
                         ,"Int")
        
        throw OSError(HRESULT, A_ThisFunc)
    
    return HRESULT
}
