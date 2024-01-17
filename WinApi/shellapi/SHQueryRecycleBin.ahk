#Requires AutoHotkey v2.0+

SHQueryRecycleBin(pszRootPath, pSHQueryRBInfo)
{
    ;// https://tinyurl.com/shellapi-shqueryrecyclebinw
    
    if SHSTDAPI := DllCall("shell32\SHQueryRecycleBin"
                          ,pszRootPath is Integer ? "Ptr" : "WStr", pszRootPath
                          ,"Ptr", pSHQueryRBInfo
                          ,"Int")
        throw Error(SHSTDAPI, A_ThisFunc, A_LastError)
    
    return SHSTDAPI
}
