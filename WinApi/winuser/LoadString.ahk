#Requires AutoHotkey v2.0+

LoadString(hInstance, uID)
{
    ;// https://bit.ly/4cITmXw
    
    if cch := DllCall("user32\LoadStringW"
                     ,"Ptr", hInstance
                     ,"UInt", uID
                     ,"PtrP", &(lp := 0)
                     ,"Int", 0
                     ,"Int")
        
        return StrGet(lp, cch)
    
    throw OSError(A_LastError)
}
