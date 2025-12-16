#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include const\NULL.ahk
#Include combaseapi\CLSIDFromString.ahk
#Include combaseapi\CoTaskMemFree.ahk
#Include winerror\FAILED.ahk

SHGetKnownFolderPath(szGUID, dwFlags, hToken)
{
    try
        guidInstance := CLSIDFromString(szGUID)
    catch OSError as err
        throw OSError(err.Number, HERE)
        
    pszPath := NULL
    hr := DllCall("shell32\SHGetKnownFolderPath", "Ptr", guidInstance, "UInt", dwFlags, "Ptr", hToken, "PtrP", &pszPath, "Int")
    
    if FAILED(hr)
    {
        if pszPath
            CoTaskMemFree(pszPath)
            
        throw OSError(hr, HERE)
    }
    
    szPath := StrGet(pszPath)
    CoTaskMemFree(pszPath)
    
    return szPath
}
