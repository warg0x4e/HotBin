#Requires AutoHotkey v2.0+

LoadLibraryEx(szLibFileName, hFile, dwFlags)
{
    ;// https://bit.ly/3XMj4WV
    
    if hLibModule := DllCall("kernel32\LoadLibraryExW"
                            ,"WStr", szLibFileName
                            ,"Ptr", hFile
                            ,"UInt", dwFlags
                            ,"Ptr")
        
        return hLibModule
        
    throw OSError(A_LastError)
}
