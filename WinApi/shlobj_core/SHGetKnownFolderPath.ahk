#Requires AutoHotkey v2.0+

SHGetKnownFolderPath(rfid, dwFlags, hToken)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath
    
    if HRESULT := DllCall("shell32\SHGetKnownFolderPath"
                         ,"Ptr", rfid
                         ,"UInt", dwFlags
                         ,"Ptr", hToken
                         ,"PtrP", &(ppszPath := 0)
                         ,"Int")
    {
        CoTaskMemFree(ppszPath)
        throw OSError(A_LastError, A_ThisFunc, HRESULT)
    }
    
    szPath := StrGet(ppszPath, "UTF-16")
    CoTaskMemFree(ppszPath)
    return szPath
}

#Include %A_LineFile%\..\..
#Include combaseapi\CoTaskMemFree.ahk
