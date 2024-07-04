#Requires AutoHotkey v2.0+

FreeLibrary(hLibModule)
{
    ;// https://bit.ly/3XMIDrc
    
    if !DllCall("kernel32\FreeLibrary"
               ,"Ptr", hLibModule
               ,"Int")
        
        throw OSError(A_LastError)
}
