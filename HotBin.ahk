;@Ahk2Exe-Let AppVersion = 2.9.0.0
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

NONE := ""
NULL := 0

LOCALAPPDATA := EnvGet("LOCALAPPDATA")

;// imageres.dll
ICON_RECYCLER_EMPTY := -55
ICON_RECYCLER_ERROR := -5305
ICON_RECYCLER_FULL := -54

;// https://github.com/AutoHotkey/AutoHotkey/blob/v2.0/source/hook.h
AHK_NOTIFYICON := 0x404

;// winerror.h
ERROR_NOT_SUPPORTED := 0x32

;// winnls.h
LOCALE_IREADINGLAYOUT := 0x70
LOCALE_NAME_USER_DEFAULT := NULL

;// winuser.h
WM_INITMENUPOPUP := 0x117
WM_LBUTTONUP := 0x202
WM_MBUTTONUP := 0x208
WM_RBUTTONUP := 0x205
WS_EX_LAYOUTRTL := 0x400000

Main()
Main()
{
    if !IsWindows8Point1OrGreater()
        ExitApp ERROR_NOT_SUPPORTED
        
    if !RunAsInteractiveUser()
        ExitApp ERROR_NOT_SUPPORTED
        
    szAppId := "{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}"
    
    try CreateMutex NULL, false, szAppId
    
    if A_LastError
        ExitApp A_LastError
        
    try DirCreate LOCALAPPDATA "\HotBin"
    
    try
        TrayMenu.Load
    catch OSError as Err
        ExitApp Err.Number
    
    NativeLanguage.DeleteProp "bRTL"
    NativeLanguage.DeleteProp "szClose"
        
    ProcessSetPriority "Low"
}

class NativeLanguage
{
    static Load()
    {
        try
        {
            hMMRes := LoadLibrary("mmres")
            hMSTask := LoadLibrary("mstask")
            hShell32 := LoadLibrary("shell32")
            
            this.bRTL := GetLocaleInfoEx(NULL, LOCALE_IREADINGLAYOUT) = 1
            this.szClose := LoadString(hShell32, 12851)
            this.szEmptyRecycleBin := LoadString(hMMRes, 5831)
            this.szError := LoadString(hShell32, 51248)
            this.szHelp := LoadString(hShell32, 30489)
            this.szItem := LoadString(hShell32, 38193)
            this.szItems := LoadString(hShell32, 38192)
            this.szOpen := LoadString(hShell32, 12850)
            this.szRunAtUserLogon := LoadString(hMSTask, 1130)
        }
        catch
        {
            this.bRTL := false
            this.szClose := "Close"
            this.szEmptyRecycleBin := "Empty Recycle Bin"
            this.szError := "Error"
            this.szHelp := "Help"
            this.szItem := "%s item"
            this.szItems := "%s items"
            this.szOpen := "Open"
            this.szRunAtUserLogon := "Run at user logon"
        }
        
        if IsSet(hMMRes)
            try FreeLibrary hMMRes
            
        if IsSet(hMSTask)
            try FreeLibrary hMSTask
            
        if IsSet(hShell32)
            try FreeLibrary hShell32
            
        this.DeleteProp "Load"
    }
}

class RunAtUserLogon
{
    static szKey := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
    
    static Load()
    {
        try
            RegRead this.szKey, "HotBin"
        catch
            this.Disable
        else
            this.Update
            
        OnExit ObjBindMethod(this, "Update")
        
        this.DeleteProp "Load"
    }
    
    static Disable()
    {
        try RegWrite "030000", "REG_BINARY", this.szKey, "HotBin"
        
        this.Update
    }
    
    static IsDisabled()
    {
        return Mod(SubStr(RegRead(this.szKey, "HotBin", "00"), 2, 1), 2) = 1
    }
    
    static Enable()
    {
        try RegWrite "020000", "REG_BINARY", this.szKey, "HotBin"
        
        this.Update
    }
    
    static IsEnabled()
    {
        return Mod(SubStr(RegRead(this.szKey, "HotBin", "00"), 2, 1), 2) = 0
    }
    
    static Toggle()
    {
        if this.IsEnabled()
            this.Disable
        else
            this.Enable
    }
    
    static Update(*)
    {
        try RegWrite GetCommandLine()
                    ,"REG_SZ"
                    ,"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                    ,"HotBin"
    }
}

class TrayMenu
{
    static pSHQueryRBInfo := SHQUERYRBINFO()
    
    static Load()
    {
        NativeLanguage.Load
        RunAtUserLogon.Load
        
        bRTL := NativeLanguage.bRTL
        szClose := NativeLanguage.szClose
        szEmptyRecycleBin := NativeLanguage.szEmptyRecycleBin
        szHelp := NativeLanguage.szHelp
        szOpen := NativeLanguage.szOpen
        szRunAtUserLogon := NativeLanguage.szRunAtUserLogon
        
        A_TrayMenu.Delete
        
        A_TrayMenu.Add "1", (*) => NULL
        A_TrayMenu.Add "2", (*) => NULL
        A_TrayMenu.Add
        A_TrayMenu.Add szRunAtUserLogon, (*) => RunAtUserLogon.Toggle()
        A_TrayMenu.Add
        A_TrayMenu.Add szOpen, (*) => this.Open()
        A_TrayMenu.Add
        A_TrayMenu.Add szEmptyRecycleBin, (*) => this.Empty()
        A_TrayMenu.Add
        A_TrayMenu.Add szHelp, (*) => this.Help()
        A_TrayMenu.Add
        A_TrayMenu.Add szClose, (*) => Close()
        
        A_TrayMenu.ClickCount := 1
        
        WinSetExStyle bRTL ? +WS_EX_LAYOUTRTL : -WS_EX_LAYOUTRTL, A_ScriptHwnd
        
        OnMessage AHK_NOTIFYICON, On_AHK_NOTIFYICON
        OnMessage WM_INITMENUPOPUP, On_WM_INITMENUPOPUP
        
        this.UpdateIcon
        
        SetTimer ObjBindMethod(this, "UpdateIcon"), 500
        
        A_IconHidden := false
        
        this.DeleteProp "Load"
    }
    
    static Empty()
    {
        try SHEmptyRecycleBin NULL, NONE, 0
    }
    
    static Help()
    {
        try Run "https://github.com/warg0x4e/HotBin/issues"
    }
    
    static Open()
    {
        try Run "shell:RecycleBinFolder"
    }
    
    static SetCustomMenuItemIcon(szMenuItem, szIcon)
    {
        Loop Parse LOCALAPPDATA "\HotBin|" A_ScriptDir, "|"
        {
            try
            {
                A_TrayMenu.SetIcon szMenuItem, A_LoopField "\" szIcon
                return true
            }
        }
        
        return false
    }
    
    static SetCustomTrayIcon(szIcon)
    {
        Loop Parse LOCALAPPDATA "\HotBin|" A_ScriptDir, "|"
        {
            try
            {
                TraySetIcon A_LoopField "\" szIcon
                return true
            }
        }
        
        return false
    }
    
    static UpdateIcon()
    {
        static i64PrevSize := -1
              ,i64PrevNumItems := -1
              ,pSHQueryRBInfo := this.pSHQueryRBInfo
        
        szError := NativeLanguage.szError
        szItem := NativeLanguage.szItem
        szItems := NativeLanguage.szItems
        
        try
            SHQueryRecycleBin NONE, pSHQueryRBInfo
        catch
        {
            A_IconTip := szError
            
            if !this.SetCustomTrayIcon("error.ico")
                TraySetIcon "imageres", ICON_RECYCLER_ERROR
            
            return
        }
        
        i64Size := pSHQueryRBInfo.i64Size
        i64NumItems := pSHQueryRBInfo.i64NumItems
        
        if i64Size = i64PrevSize && i64NumItems = i64PrevNumItems
            ;// No change.
            return
            
        i64PrevSize := i64Size
        i64PrevNumItems := i64NumItems
        
        try
            szSize := StrFormatByteSize(i64Size)
        catch
            szSize := szError
            
        szNumItems := StrReplace(i64NumItems = 1
                                ? szItem
                                : szItems
                                ,"%s"
                                ,i64NumItems)
        
        A_IconTip := szSize "`n" szNumItems
        
        if i64NumItems
        {
            if !this.SetCustomTrayIcon("full.ico")
                TraySetIcon "imageres", ICON_RECYCLER_FULL
        }
        else
        {
            if !this.SetCustomTrayIcon("empty.ico")
                TraySetIcon "imageres", ICON_RECYCLER_EMPTY
        }
    }
    
    static UpdateMenu()
    {
        static i64PrevSize := -1
              ,i64PrevNumItems := -1
              ,pSHQueryRBInfo := this.pSHQueryRBInfo
        
        szEmptyRecycleBin := NativeLanguage.szEmptyRecycleBin
        szError := NativeLanguage.szError
        szItem := NativeLanguage.szItem
        szItems := NativeLanguage.szItems
        szRunAtUserLogon := NativeLanguage.szRunAtUserLogon
        
        if RunAtUserLogon.IsEnabled()
            A_TrayMenu.Check szRunAtUserLogon
        else
            A_TrayMenu.Uncheck szRunAtUserLogon
        
        try
            SHQueryRecycleBin NONE, pSHQueryRBInfo
        catch
        {
            A_TrayMenu.Rename "1&", szError
            A_TrayMenu.Rename "2&", szError
            
            A_TrayMenu.Disable szEmptyRecycleBin
            
            if !this.SetCustomMenuItemIcon(szEmptyRecycleBin, "error.ico")
                A_TrayMenu.SetIcon szEmptyRecycleBin
                                  ,"imageres"
                                  ,ICON_RECYCLER_ERROR
            
            return
        }
        
        i64Size := pSHQueryRBInfo.i64Size
        i64NumItems := pSHQueryRBInfo.i64NumItems
        
        if i64Size = i64PrevSize && i64NumItems = i64PrevNumItems
            ;// No change.
            return
            
        i64PrevSize := i64Size
        i64PrevNumItems := i64NumItems
        
        try
            szSize := StrFormatByteSize(i64Size)
        catch
            szSize := szError
            
        szNumItems := StrReplace(i64NumItems = 1
                                 ? szItem
                                 : szItems
                                ,"%s"
                                ,i64NumItems)
        
        A_TrayMenu.Rename "1&", szSize
        A_TrayMenu.Rename "2&", szNumItems
        
        if i64NumItems
        {
            A_TrayMenu.Enable szEmptyRecycleBin
            
            if !this.SetCustomMenuItemIcon(szEmptyRecycleBin, "full.ico")
                A_TrayMenu.SetIcon szEmptyRecycleBin
                                  ,"imageres"
                                  ,ICON_RECYCLER_FULL
        }
        else
        {
            A_TrayMenu.Disable szEmptyRecycleBin
            
            if !this.SetCustomMenuItemIcon(szEmptyRecycleBin, "empty.ico")
                A_TrayMenu.SetIcon szEmptyRecycleBin
                                  ,"imageres"
                                  ,ICON_RECYCLER_EMPTY
        }
    }
}

IsWindows8Point1OrGreater()
{
    szKey := "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    
    return VerCompare(RegRead(szKey, "CurrentVersion", "0.0"), ">=6.3")
}

On_AHK_NOTIFYICON(wParam, lParam, *)
{
    switch lParam
    {
        case WM_LBUTTONUP, WM_RBUTTONUP:
            A_TrayMenu.Show
            
        case WM_MBUTTONUP:
            RecycleBin.Open
    }
        
    return 0
}

On_WM_INITMENUPOPUP(*)
{
    TrayMenu.UpdateMenu
    
    return 0
}

Close()
{
    if GetKeyState("Ctrl")
        Reload
    else
        ExitApp
}

RunAsInteractiveUser()
{
    if A_IsAdmin
        try WdcRunTaskAsInteractiveUser GetCommandLine(), A_ScriptDir
        
    return !A_IsAdmin
}

;//=============================================================================
;//                                  WinApi
;//=============================================================================

WdcRunTaskAsInteractiveUser(pwszCmdLine, pwszPath)
{
    return DllCall("wdc\WdcRunTaskAsInteractiveUser"
                  ,"WStr", pwszCmdLine
                  ,"WStr", pwszPath
                  ,"UInt", 0
                  ,"HRESULT")
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
