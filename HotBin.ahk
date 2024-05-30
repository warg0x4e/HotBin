;@Ahk2Exe-Let AppVersion = 2.7.16.1
;@Ahk2Exe-SetCompanyName warg0x4e
;@Ahk2Exe-SetCopyright The Unlicense
;@Ahk2Exe-SetDescription HotBin
;@Ahk2Exe-SetName HotBin
;@Ahk2Exe-SetVersion %U_AppVersion%
;@Ahk2Exe-UpdateManifest 0, HotBin, %U_AppVersion%, 0

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

global IMAGERES_RECYCLER := 51
      ,IMAGERES_RECYCLER_ERROR := 246
      ,IMAGERES_RECYCLER_FULL := 50

Main()
Main()
{
    RunAsInteractiveUser()
    
    if RegRead("HKCU\SOFTWARE\HotBin", "RunAtStartup", 0)
        RunAtStartup.Enable()
    
    ;// HotBin.iss
    ;// https://jrsoftware.org/ishelp/index.php?topic=runsection
    try
        if A_Args[1] = "/RunAtStartup"
            RunAtStartup.Enable()
    
    ;// HotBin.iss
    ;// https://jrsoftware.org/ishelp/index.php?topic=setup_appmutex
    try CreateMutex(NULL, false, "{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}")
    
    if A_LastError
        ExitApp A_LastError
    
    MUI.Load()
    CreateMenu()
    
    ;// Free memory.
    MUI.DeleteProp "bRTL"
    MUI.DeleteProp "szClose"
    MUI.DeleteProp "szOpen"
    
    shqrbi := SHQUERYRBINFO()
    
    UpdateIcon(shqrbi)
    SetTimer UpdateIcon.Bind(shqrbi), 500
    
    ;// https://learn.microsoft.com/en-us/windows/win32/menurc/wm-initmenupopup
    OnMessage WM_INITMENUPOPUP := 0x117, UpdateMenu.Bind(shqrbi)
    
    ProcessSetPriority "Low"
    A_IconHidden := false
}

class MUI
{
    static bRTL := false
          ,szClose := "Close"
          ,szEmptyRecycleBin := "Empty Recycle Bin"
          ,szError := "Error"
          ,szItem := "%s item"
          ,szItems := "%s items"
          ,szOpen := "Open"
          ,szStartup := "Startup"
    
    static Load()
    {
        ;// https://learn.microsoft.com/en-us/windows/win32/intl/locale-name-constants
        LOCALE_NAME_USER_DEFAULT := NULL
        
        ;// https://learn.microsoft.com/en-us/windows/win32/intl/locale-ireadinglayout
        LOCALE_IREADINGLAYOUT := 0x70
        
        ;// https://learn.microsoft.com/en-us/windows/win32/intl/locale-return-constants
        LOCALE_RETURN_NUMBER := 0x20000000
        
        LCType := LOCALE_IREADINGLAYOUT | LOCALE_RETURN_NUMBER
        
        try
        {
            hMMRes := LoadLibrary("mmres")
            hShell32 := LoadLibrary("shell32")
            
            szClose := LoadString(hShell32, 12851)
            szEmptyRecycleBin := LoadString(hMMRes, 5831)
            szError := LoadString(hShell32, 51248)
            szItem := LoadString(hShell32, 38193)
            szItems := LoadString(hShell32, 38192)
            szOpen := LoadString(hShell32, 12850)
            szStartup := LoadString(hShell32, 21787)
            
            bRTL := GetLocaleInfoEx(LOCALE_NAME_USER_DEFAULT, LCType) = 1
        }
        catch
            return
        finally
        {
            if IsSet(hMMRes)
                try FreeLibrary(hMMRes)
            if IsSet(hShell32)
                try FreeLibrary(hShell32)
        }
        
        this.bRTL := bRTL
        this.szClose := szClose
        this.szEmptyRecycleBin := szEmptyRecycleBin
        this.szError := szError
        this.szItem := szItem
        this.szItems := szItems
        this.szOpen := szOpen
        this.szStartup := szStartup
    }
}

class RunAtStartup
{
    
    static Disabled() => !this.Enabled()
    
    static Enable()
    {
        try
        {
            RegWrite '"' A_ScriptFullPath '"'
                    ,"REG_SZ"
                    ,"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                    ,"HotBin"
        }
        catch
            return
            
        try
        {
            RegWrite "1"
                    ,"REG_SZ"
                    ,"HKCU\SOFTWARE\HotBin"
                    ,"RunAtStartup"
        }
    }
    
    static Enabled()
    {
        return RegRead("HKCU\SOFTWARE\HotBin", "RunAtStartup", 0) = 1
    }
    
    static Disable()
    {
        try
        {
            RegDelete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                     ,"HotBin"
        }
        catch
            return
        
        try
        {
            RegDelete "HKCU\SOFTWARE\HotBin"
                     ,"RunAtStartup"
        }
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
    A_TrayMenu.Delete
    
    A_TrayMenu.Add "1", (*) => NULL
    A_TrayMenu.Add "2", (*) => NULL
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
    
    ;// https://learn.microsoft.com/en-us/windows/win32/winmsg/extended-window-styles
    WS_EX_LAYOUTRTL := 0x400000
    
    WinSetExStyle MUI.bRTL ? +WS_EX_LAYOUTRTL : -WS_EX_LAYOUTRTL, A_ScriptHwnd
}

EmptyRecycleBin()
{
    try SHEmptyRecycleBin(NULL, NULL, NULL)
}

OpenRecycleBin()
{
    try Run "shell:RecycleBinFolder"
}

RunAsInteractiveUser()
{
    if A_IsAdmin
    {
        try WdcRunTaskAsInteractiveUser(A_ScriptFullPath, A_ScriptDir)
        
        ExitApp A_LastError
    }
}

UpdateIcon(shqrbi)
{
    static i64PrevSize := -1
          ,i64PrevNumItems := -1
    
    try
        SHQueryRecycleBin(NONE, shqrbi)
    catch
    {
        ;// Never should occur.
        A_IconTip := MUI.szError
        TraySetIcon "imageres", IMAGERES_RECYCLER_ERROR
        return
    }
    
    i64Size := shqrbi.i64Size
    i64NumItems := shqrbi.i64NumItems
    
    if i64Size = i64PrevSize && i64NumItems = i64PrevNumItems
        ;// No change.
        return
    
    i64PrevSize := i64Size
    i64PrevNumItems := i64NumItems
    
    try
        szSize := StrFormatByteSize(i64Size)
    catch
        ;// Never should occur.
        szSize := MUI.szError
        
    szNumItems := StrReplace(i64NumItems = 1 ? MUI.szItem : MUI.szItems
                            ,"%s"
                            ,i64NumItems)
    
    A_IconTip := szNumItems "`n" szSize
    
    TraySetIcon "imageres", i64NumItems
                          ? IMAGERES_RECYCLER_FULL
                          : IMAGERES_RECYCLER
}

UpdateMenu(shqrbi, *)
{
    static i64PrevSize := -1
          ,i64PrevNumItems := -1
    
    if RunAtStartup.Enabled()
        A_TrayMenu.Check MUI.szStartup
    else
        A_TrayMenu.Uncheck MUI.szStartup
    
    try
        SHQueryRecycleBin(NONE, shqrbi)
    catch
    {
        ;// Never should occur.
        A_TrayMenu.Rename "1&", MUI.szError
        A_TrayMenu.Rename "2&", MUI.szError
        A_TrayMenu.Enable MUI.szEmptyRecycleBin 
        A_TrayMenu.SetIcon MUI.szEmptyRecycleBin
                          ,"imageres"
                          ,IMAGERES_RECYCLER_ERROR
        return
    }
    
    i64Size := shqrbi.i64Size
    i64NumItems := shqrbi.i64NumItems
    
    if i64Size = i64PrevSize && i64NumItems = i64PrevNumItems
        ;// No change.
        return
    
    i64PrevSize := i64Size
    i64PrevNumItems := i64NumItems
    
    try
        szSize := StrFormatByteSize(i64Size)
    catch
        ;// Never should occur.
        szSize := MUI.szError
        
    szNumItems := StrReplace(i64NumItems = 1 ? MUI.szItem : MUI.szItems
                            ,"%s"
                            ,i64NumItems)
    
    A_TrayMenu.Rename "1&", szNumItems
    A_TrayMenu.Rename "2&", szSize
    
    if i64NumItems
    {
        A_TrayMenu.Enable MUI.szEmptyRecycleBin
        A_TrayMenu.SetIcon MUI.szEmptyRecycleBin
                          ,"imageres"
                          ,IMAGERES_RECYCLER_FULL
    }
    else
    {
        A_TrayMenu.Disable MUI.szEmptyRecycleBin
        A_TrayMenu.SetIcon MUI.szEmptyRecycleBin
                          ,"imageres"
                          ,IMAGERES_RECYCLER
    }
}

;===============================================================================
;                                 WinApi
;===============================================================================

WdcRunTaskAsInteractiveUser(pwszCmdLine, pwszPath)
{
    ;// Not documented?
    
    if HRESULT := DllCall("wdc\WdcRunTaskAsInteractiveUser"
                         ,pwszCmdLine is Integer ? "Ptr" : "WStr", pwszCmdLine
                         ,pwszPath is Integer ? "Ptr" : "WStr", pwszPath
                         ,"UInt", 0
                         ,"Int")
        
        throw OSError(HRESULT, A_ThisFunc)
    
    return HRESULT
}

#Include WinApi\libloaderapi\FreeLibrary.ahk
#Include WinApi\libloaderapi\LoadLibrary.ahk
#Include WinApi\shellapi\SHEmptyRecycleBin.ahk
#Include WinApi\shellapi\SHQUERYRBINFO.ahk
#Include WinApi\shellapi\SHQueryRecycleBin.ahk
#Include WinApi\shlwapi\StrFormatByteSize.ahk
#Include WinApi\synchapi\CreateMutex.ahk
#Include WinApi\winnls\GetLocaleInfoEx.ahk
#Include WinApi\winuser\LoadString.ahk
