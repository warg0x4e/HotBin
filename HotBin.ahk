;@Ahk2Exe-SetCompanyName warg0x4e
;@Ahk2Exe-SetCopyright The Unlicense
;@Ahk2Exe-SetDescription HotBin
;@Ahk2Exe-SetName HotBin
;@Ahk2Exe-SetOrigFilename HotBin.exe
;@Ahk2Exe-SetVersion 2.7.0.0
;@Ahk2Exe-UpdateManifest 0, HotBin, 2.7.0.0, 0

#Requires AutoHotkey v2.0+

#NoTrayIcon
#SingleInstance Off
#Warn All, Off

KeyHistory 0
ListLines false
Persistent

InstallKeybdHook false
InstallMouseHook false

global NONE := ""
      ,NULL := 0

Main()
Main()
{
    ProcessSetPriority "Low"
    SetWorkingDir A_ScriptDir

    RunAsUser()
    
    ;// HotBin.iss
    for _, szArg in A_Args
        if szArg = "/runatstartup"
            RunAtStartup.Enable()
            
    szAppId := "{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}"
    
    ;// https://jrsoftware.org/ishelp/index.php?topic=setup_appmutex
    try CreateMutex(NULL, false, szAppId)
    
    if A_LastError
        ExitApp A_LastError
        
    MUI.Load()
    CreateMenu()
    
    ;// Free memory.
    MUI.DeleteProp("szClose")
    MUI.DeleteProp("szOpen")
    
    shqrbi := SHQUERYRBINFO()
    
    UpdateIcon(shqrbi)
    SetTimer UpdateIcon.Bind(shqrbi), 500
    
    OnMessage WM_INITMENUPOPUP := 0x117, UpdateMenu.Bind(shqrbi)
    
    A_IconHidden := false
}

class MUI
{
    static bRTL := false
          ,szClose := "Close"
          ,szEmptyRecycleBin := "Empty Recycle Bin"
          ,szItem := "%s item"
          ,szItems := "%s items"
          ,szOpen := "Open"
          ,szStartup := "Startup"
    
    static Load()
    {
        LOCALE_NAME_USER_DEFAULT := NULL
        
        LOCALE_IREADINGLAYOUT := 0x70
        LOCALE_RETURN_NUMBER := 0x20000000
        
        LCType := LOCALE_IREADINGLAYOUT | LOCALE_RETURN_NUMBER
        
        try
        {
            bRTL := GetLocaleInfoEx(LOCALE_NAME_USER_DEFAULT, LCType) = 1
            
            hMMRes := LoadLibrary("mmres")
            hShell32 := LoadLibrary("shell32")
            
            szClose := LoadString(hShell32, 12851)
            szEmptyRecycleBin := LoadString(hMMRes, 5831)
            szItem := LoadString(hShell32, 38193)
            szItems := LoadString(hShell32, 38192)
            szOpen := LoadString(hShell32, 12850)
            szStartup := LoadString(hShell32, 21787)
            
            FreeLibrary(hMMRes)
            FreeLibrary(hShell32)
        }
        catch
            return
            
        MUI.bRTL := bRTL
        MUI.szClose := szClose
        MUI.szEmptyRecycleBin := szEmptyRecycleBin
        MUI.szItem := szItem
        MUI.szItems := szItems
        MUI.szOpen := szOpen
        MUI.szStartup := szStartup
    }
}

class RunAtStartup
{
    static Disable()
    {
        szRegKeyName := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        
        try RegDelete szRegKeyName, "HotBin"
    }
    
    static Disabled()
    {
        return !this.Enabled()
    }
    
    static Enable()
    {
        szRegKeyName := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        
        try RegWrite A_ScriptFullPath, "REG_SZ", szRegKeyName, "HotBin"
    }
    
    static Enabled()
    {
        szRegKeyName := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        
        szRegRead := RegRead(szRegKeyName, "HotBin", NONE)
        
        return szRegRead = A_ScriptFullPath
    }
    
    static Toggle()
    {
        if this.Enabled()
            this.Disable()
        else
            this.Enable()
    }
}

CreateMenu()
{
    WS_EX_LAYOUTRTL := 0x400000
    
    WinSetExStyle MUI.bRTL ? +WS_EX_LAYOUTRTL : -WS_EX_LAYOUTRTL, A_ScriptHwnd
    
    A_TrayMenu.Delete
    
    A_TrayMenu.Add "1", (*) => false
    A_TrayMenu.Add "2", (*) => false
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szStartup, (*) => RunAtStartup.Toggle()
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szOpen, (*) => OpenRecycleBin()
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szEmptyRecycleBin, (*) => EmptyRecycleBin()
    A_TrayMenu.Add
    A_TrayMenu.Add MUI.szClose, (*) => ExitApp()
    
    A_TrayMenu.ClickCount := 1
    A_TrayMenu.Default := MUI.szOpen
}

EmptyRecycleBin()
{
    try SHEmptyRecycleBin(NULL, NULL, NULL)
}

OpenRecycleBin()
{
    try Run "shell:RecycleBinFolder"
}

RunAsUser()
{
    if A_IsAdmin
    {
        try WdcRunTaskAsInteractiveUser(GetCommandLine(), NULL)
        
        ExitApp ERROR_ACCESS_DENIED := 0x5
    }
}

UpdateIcon(shqrbi)
{
    static i64Size := -1
          ,i64NumItems := -1
    
    try SHQueryRecycleBin(NULL, shqrbi)
    
    if shqrbi.i64Size = i64Size && shqrbi.i64NumItems = i64NumItems
        ;// No change.
        return
        
    i64Size := shqrbi.i64Size
    i64NumItems := shqrbi.i64NumItems
    
    szSize := StrFormatByteSize(i64Size)
    szNumItems := StrReplace(i64NumItems = 1 ? MUI.szItem : MUI.szItems
                            ,"%s"
                            ,i64NumItems)
    
    A_IconTip := szNumItems "`n" szSize
    
    TraySetIcon "shell32", i64NumItems
                           ? -SHSTOCKICONID.SIID_RECYCLERFULL
                           : -SHSTOCKICONID.SIID_RECYCLER
}

UpdateMenu(shqrbi, *)
{ 
    try SHQueryRecycleBin(NULL, shqrbi)
        
    i64Size := shqrbi.i64Size
    i64NumItems := shqrbi.i64NumItems
    
    szSize := StrFormatByteSize(i64Size)
    szNumItems := StrReplace(i64NumItems = 1 ? MUI.szItem : MUI.szItems
                            ,"%s"
                            ,i64NumItems)
    
    A_TrayMenu.Rename "1&", szNumItems
    A_TrayMenu.Rename "2&", szSize
    
    if RunAtStartup.Enabled()
        A_TrayMenu.Check MUI.szStartup
    else
        A_TrayMenu.Uncheck MUI.szStartup
    
    if i64NumItems
    {
        A_TrayMenu.Enable  MUI.szEmptyRecycleBin
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
    ;// https://learn.microsoft.com/en-us/windows/win32/api/shellapi/ne-shellapi-shstockiconid
    
    static SIID_RECYCLER := 32
          ,SIID_RECYCLERFULL := 33
}

WdcRunTaskAsInteractiveUser(pwszCmdLine, pwszPath)
{
    ;// Not documented?
    
    if HRESULT := DllCall("wdc\WdcRunTaskAsInteractiveUser"
                         ,pwszCmdLine is Integer ? "Ptr" : "WStr", pwszCmdLine
                         ,pwszPath is Integer ? "Ptr" : "WStr", pwszPath
                         ,"UInt", 0
                         ,"Int")
        
        throw Error(HRESULT, A_ThisFunc, A_LastError)
        
    return HRESULT
}

#Include WinApi\libloaderapi\FreeLibrary.ahk
#Include WinApi\libloaderapi\LoadLibrary.ahk
#Include WinApi\processenv\GetCommandLine.ahk
#Include WinApi\shellapi\SHEmptyRecycleBin.ahk
#Include WinApi\shellapi\SHQUERYRBINFO.ahk
#Include WinApi\shellapi\SHQueryRecycleBin.ahk
#Include WinApi\shlwapi\StrFormatByteSize.ahk
#Include WinApi\synchapi\CreateMutex.ahk
#Include WinApi\winnls\GetLocaleInfoEx.ahk
#Include WinApi\winuser\LoadString.ahk
