#Requires AutoHotkey v2.0+

CoTaskMemFree(pv)
{
    ;// https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-cotaskmemfree
    
    return DllCall("ole32\CoTaskMemFree"
                  ,"Ptr", pv
                  ,"Ptr")
}
