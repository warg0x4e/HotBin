#Requires AutoHotkey v2.0+

CoTaskMemFree(pv)
{
    DllCall("ole32\CoTaskMemFree", "Ptr", pv)
}
