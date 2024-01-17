;@Ahk2Exe-SetCompanyName warg0x4e
;@Ahk2Exe-SetCopyright The Unlicense
;@Ahk2Exe-SetDescription HotBin
;@Ahk2Exe-SetName HotBin
;@Ahk2Exe-SetOrigFilename HotBin.exe
;@Ahk2Exe-SetVersion 2.6.8.0
;@Ahk2Exe-UpdateManifest 0, HotBin, 2.6.8.0, 0

#Requires AutoHotkey v2.0+
#NoTrayIcon
#SingleInstance Off
#Warn All, Off

global NONE := ""
      ,NULL := 0

Main()
Main()
{
    KeyHistory 0
    ListLines false
    Persistent
    ProcessSetPriority "Low"
    
    InstallKeybdHook false
    InstallMouseHook false
    
    NoAdmin()
    
    for _, szArg in A_Args
        if szArg = "/runatstartup"
            RunAtStartup.Enable()
    
    AppId := "{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}"
    
    ERROR_ALREADY_EXISTS := 0xB7
    
    ;// https://tinyurl.com/appmutex
    CreateMutex(NULL, false, AppId)
    
    if A_LastError = ERROR_ALREADY_EXISTS
        ExitApp ERROR_ALREADY_EXISTS
    
    MUI := CreateMUI()
    SHQRBI := SHQUERYRBINFO()
    
    CreateMenu(MUI)
    
    UpdateIcon(MUI, SHQRBI)
    A_IconHidden := false
    
    SetTimer UpdateIcon.Bind(MUI, SHQRBI), 500
    OnMessage WM_INITMENUPOPUP := 0x117, UpdateMenu.Bind(MUI, SHQRBI)
}

CreateMenu(MUI)
{
    WS_EX_LAYOUTRTL := 0x400000
    WinSetExStyle MUI.bRTL ? +WS_EX_LAYOUTRTL : -WS_EX_LAYOUTRTL, A_ScriptHwnd
    
    A_TrayMenu.Delete
    
    A_TrayMenu.Add "1", (*) => IsSet(DEBUG) && DEBUG ? Reload() : false
    A_TrayMenu.Add "2", (*) => IsSet(DEBUG) && DEBUG ? Reload() : false
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szStartup, (*) => RunAtStartup.Toggle()
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szOpen, (*) => Run("shell:RecycleBinFolder")
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szEmptyRecycleBin, (*) => EmptyRecycleBin()
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szClose, (*) => ExitApp()
    
    A_TrayMenu.ClickCount := 1
    A_TrayMenu.Default := MUI.szOpen
}

CreateMUI()
{
    MUI := {}
    
    LOCALE_IREADINGLAYOUT := 0x70
    LOCALE_NAME_USER_DEFAULT := NULL
    LOCALE_RETURN_NUMBER := 0x20000000
    
    try
    {
        GetLocaleInfoEx(LOCALE_NAME_USER_DEFAULT
                       ,LOCALE_IREADINGLAYOUT | LOCALE_RETURN_NUMBER
                       ,lpLCData := Buffer(4, NULL))
        
        MUI.bRTL := NumGet(lpLCData, "UInt") = 1
        
        hShell32 := LoadLibrary("shell32")
        MUI.szClose := LoadString(hShell32, 12851)
        MUI.szItem := LoadString(hShell32, 38193)
        MUI.szItems := LoadString(hShell32, 38192)
        MUI.szOpen := LoadString(hShell32, 12850)
        MUI.szStartup := LoadString(hShell32, 21787)
        FreeLibrary(hShell32)
        
        hMMRes := LoadLibrary("mmres")
        MUI.szEmptyRecycleBin := LoadString(hMMRes, 5831)
        FreeLibrary(hMMRes)
    }
    catch
    {
        MUI.bRTL := false
        MUI.szClose := "Close"
        MUI.szEmptyRecycleBin := "Empty Recycle Bin"
        MUI.szItem := "%s item"
        MUI.szItems := "%s items"
        MUI.szOpen := "Open"
        MUI.szStartup := "Startup"
    }
    
    return MUI
}

EmptyRecycleBin()
{
    try SHEmptyRecycleBin(NULL, NULL, NULL)
}

NoAdmin()
{
    if A_IsAdmin
    {
        try WdcRunTaskAsInteractiveUser(GetCommandLine(), NULL, 0x27)
        
        ExitApp ERROR_ACCESS_DENIED := 0x5
    }
}

class RunAtStartup
{
    static szRegKeyName := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
          ,szRegValData := '"' A_ScriptFullPath '"'
          ,szRegValName := "HotBin"
          ,szRegValType := "REG_SZ"
          
    static Enable()
    {
        try RegWrite RunAtStartup.szRegValData, RunAtStartup.szRegValType
                    ,RunAtStartup.szRegKeyName, RunAtStartup.szRegValName
    }
    
    static Enabled()
    {
        szRegRead := RegRead(RunAtStartup.szRegKeyName
                            ,RunAtStartup.szRegValName
                            ,NONE)
        return szRegRead = RunAtStartup.szRegValData
    }
    
    static Disable()
    {
        try RegDelete RunAtStartup.szRegKeyName, RunAtStartup.szRegValName
    }
    
    static Disabled()
    {
        return !RunAtStartup.Enabled()
    }
    
    static Toggle()
    {
        if RunAtStartup.Enabled()
            RunAtStartup.Disable()
        else
            RunAtStartup.Enable()
    }
}

UpdateIcon(MUI, SHQRBI)
{
    static i64Size := -1
          ,i64NumItems := -1
    
    SHQueryRecycleBin(NULL, SHQRBI)
    
    if SHQRBI.i64Size = i64Size && SHQRBI.i64NumItems = i64NumItems
        ;// No change.
        return
        
    i64Size := SHQRBI.i64Size
    i64NumItems := SHQRBI.i64NumItems
    
    szSize := StrFormatByteSize(i64Size)
    szNumItems := StrReplace(i64NumItems = 1 ? MUI.szItem : MUI.szItems
                            ,"%s"
                            ,i64NumItems)
    
    A_IconTip := szNumItems "`n" szSize
    TraySetIcon "shell32", i64NumItems
                           ? -SHSTOCKICONID.SIID_RECYCLERFULL
                           : -SHSTOCKICONID.SIID_RECYCLER
}

UpdateMenu(MUI, SHQRBI, *)
{
    static i64Size := -1
          ,i64NumItems := -1
    
    if RunAtStartup.Enabled()
        A_TrayMenu.Check MUI.szStartup
    else
        A_TrayMenu.Uncheck MUI.szStartup
    
    SHQueryRecycleBin(NULL, SHQRBI)
    
    if SHQRBI.i64Size = i64Size && SHQRBI.i64NumItems = i64NumItems
        ;// No change.
        return
        
    i64Size := SHQRBI.i64Size
    i64NumItems := SHQRBI.i64NumItems
    
    szSize := StrFormatByteSize(i64Size)
    szNumItems := StrReplace(i64NumItems = 1 ? MUI.szItem : MUI.szItems
                            ,"%s"
                            ,i64NumItems)
    
    A_TrayMenu.Rename "1&", szNumItems
    A_TrayMenu.Rename "2&", szSize
    
    if i64NumItems
    {
        A_TrayMenu.Enable MUI.szEmptyRecycleBin
        A_TrayMenu.SetIcon MUI.szEmptyRecycleBin
                          ,"shell32"
                          ,-SHSTOCKICONID.SIID_RECYCLERFULL
    }
    else
    {
        A_TrayMenu.Disable MUI.szEmptyRecycleBin
        A_TrayMenu.SetIcon MUI.szEmptyRecycleBin
                          ,"shell32"
                          ,-SHSTOCKICONID.SIID_RECYCLER
    }
}

;///////////////////////////////////////////////////////////////////////////////
;// WinApi
;///////////////////////////////////////////////////////////////////////////////

class SHSTOCKICONID
{
    ;// https://tinyurl.com/shellapi-shstockiconid
    
    static SIID_RECYCLER := 32
          ,SIID_RECYCLERFULL := 33
}

WdcRunTaskAsInteractiveUser(pwszCmdLine, pwszPath, dwDummy)
{
    ;// Not documented.
    
    if HRESULT := DllCall("wdc\WdcRunTaskAsInteractiveUser"
                         ,pwszCmdLine is Integer ? "Ptr" : "WStr", pwszCmdLine
                         ,pwszPath is Integer ? "Ptr" : "WStr", pwszPath
                         ,"UInt", dwDummy
                         ,"Int")
        throw Error(HRESULT, A_ThisFunc, A_LastError)
        
    return HRESULT
}

#Include WinApi\libloaderapi\FreeLibrary.ahk
#Include WinApi\libloaderapi\LoadLibrary.ahk
#Include WinApi\processenv\GetCommandLine.ahk
#Include WinApi\shellapi\SHEmptyRecycleBin.ahk
#Include WinAPi\shellapi\SHQUERYRBINFO.ahk
#Include WinApi\shellapi\SHQueryRecycleBin.ahk
#Include WinApi\shlwapi\StrFormatByteSize.ahk
#Include WinApi\synchapi\CreateMutex.ahk
#Include WinApi\winnls\GetLocaleInfoEx.ahk
#Include WinApi\winuser\LoadString.ahk
