#Requires AutoHotkey v2.0+

SHQueryRecycleBin(pszRootPath, pSHQueryRBInfo)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shqueryrecyclebinw
    
    if HRESULT := DllCall("shell32\SHQueryRecycleBinW"
                         ,"WStr", pszRootPath
                         ,"Ptr", pSHQueryRBInfo
                         ,"Int")
        
        throw OSError(A_LastError, A_ThisFunc, HRESULT)
        
    return HRESULT
}
