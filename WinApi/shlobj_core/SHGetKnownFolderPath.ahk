#Requires AutoHotkey v2.0+

SHGetKnownFolderPath(rfid, dwFlags, hToken)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath
    
    try
    {
        DllCall("shell32\SHGetKnownFolderPath"
               ,"Ptr", rfid
               ,"UInt", dwFlags
               ,"Ptr", hToken
               ,"PtrP", &(ppszPath := 0)
               ,"HRESULT")
        
        return StrGet(ppszPath, "UTF-16")
    }
    catch Any as Err
        throw Err
    finally
        CoTaskMemFree(ppszPath)
}

#Include %A_ScriptDir%
#Include WinApi\combaseapi\CoTaskMemFree.ahk
