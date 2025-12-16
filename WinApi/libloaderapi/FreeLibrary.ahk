#Requires AutoHotkey v2.0+

FreeLibrary(hLibModule)
{
    if !DllCall("kernel32\FreeLibrary", "Ptr", hLibModule, "Int")
        throw OSError(A_LastError, -1)
}
