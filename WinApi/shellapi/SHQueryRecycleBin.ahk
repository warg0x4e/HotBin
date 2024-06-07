#Requires AutoHotkey v2.0+

SHQueryRecycleBin(pszRootPath, pSHQueryRBInfo)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shqueryrecyclebinw
    
    return DllCall("shell32\SHQueryRecycleBinW"
                  ,"WStr", pszRootPath
                  ,"Ptr", pSHQueryRBInfo
                  ,"HRESULT")
}
