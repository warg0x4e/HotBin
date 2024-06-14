;@Ahk2Exe-Let AppVersion = 2.9.3.0
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

;// hook.h
AHK_NOTIFYICON := 0x404

;// knownfolders.h
FOLDERID_LocalAppData := "{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}"

;// shellapi.h
SHERB_NOCONFIRMATION := 0x1
SHGSI_ICON := 0x100
SHGSI_SMALLICON := 0x1
SIID_ERROR := 0x50
SIID_RECYCLER := 0x1F
SIID_RECYCLERFULL := 0x20

;// shlobj_core.h
KF_FLAG_DONT_VERIFY := 0x4000

;// winerror.h
ERROR_NOT_SUPPORTED := 0x32

;// winnls.h
LOCALE_NAME_USER_DEFAULT := NULL
LOCALE_IREADINGLAYOUT := 0x70

;// winnt.h
VER_GREATER_EQUAL := 3
VER_MAJORVERSION := 0x2
VER_MINORVERSION := 0x1
VER_SERVICEPACKMAJOR := 0x20
    
;// winuser.h
WM_INITMENUPOPUP := 0x117
WM_LBUTTONUP := 0x202
WM_MBUTTONUP := 0x208
WM_RBUTTONUP := 0x205
WS_EX_LAYOUTRTL := 0x400000

LOCALAPPDATA := SHGetKnownFolderPath(CLSIDFromString(FOLDERID_LocalAppData, GUID()), KF_FLAG_DONT_VERIFY, NULL)

Main()
Main()
{
    if !IsWindows8OrGreater()
        ExitApp ERROR_NOT_SUPPORTED
        
    if !RunAsInteractiveUser()
        ExitApp ERROR_NOT_SUPPORTED
        
    szAppId := "{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}"
    
    try CreateMutex NULL, false, szAppId
    
    if A_LastError
        ExitApp A_LastError
    
    try DirCreate LOCALAPPDATA "\HotBin"
    
    TrayMenu.Load
    
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
            
            this.bRTL := GetLocaleInfoEx(LOCALE_NAME_USER_DEFAULT, LOCALE_IREADINGLAYOUT) = 1
            this.szClose := LoadString(hShell32, 12851)
            this.szEmptyRecycleBin := LoadString(hMMRes, 5831)
            this.szError := LoadString(hShell32, 51248)
            this.szHelp := LoadString(hShell32, 30489)
            this.szItem := LoadString(hShell32, 38193)
            this.szItems := LoadString(hShell32, 38192)
            this.szOpen := LoadString(hShell32, 12850)
            this.szRunAtUserLogon := LoadString(hMSTask, 1130)
            this.szShowRecycleConfirmation := LoadString(hShell32, 37396)
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
            this.szShowRecycleConfirmation := "Show recycle confirmation"
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

class RecycleBin
{
    static Empty()
    {
        if ShowRecycleConfirmation.IsDisabled() || GetKeyState("Ctrl")
            dwFlags := SHERB_NOCONFIRMATION
        else
            dwFlags := 0
        
        try SHEmptyRecycleBin NULL, NONE, dwFlags
    }
    
    static Open()
    {
        try Run "shell:RecycleBinFolder"
    }
    
    static Query()
    {
        static pSHQueryRBInfoEx := SHQUERYRBINFOEX()
        
        SHQueryRecycleBin NONE, pSHQueryRBInfoEx
        
        return pSHQueryRBInfoEx
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
            
        if A_IsCompiled
            szCmdLine := '"' A_ScriptFullPath '"'
        else
            szCmdLine := '"' A_AhkPath '" "' A_ScriptFullPath '"'
        
        try RegWrite szCmdLine
                    ,"REG_SZ"
                    ,"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                    ,"HotBin"
        
        this.DeleteProp "Load"
    }
    
    static Disable()
    {
        try RegWrite "030000", "REG_BINARY", this.szKey, "HotBin"
    }
    
    static IsDisabled()
    {
        return Mod(SubStr(RegRead(this.szKey, "HotBin", "00"), 2, 1), 2) = 1
    }
    
    static Enable()
    {
        try RegWrite "020000", "REG_BINARY", this.szKey, "HotBin"
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
}

class ShowRecycleConfirmation
{
    static szKey := "HKCU\SOFTWARE\HotBin"
    
    static Disable()
    {
        try RegWrite 0, "REG_SZ", this.szKey, "ShowRecycleConfirmation"
    }
    
    static IsDisabled()
    {
        return RegRead(this.szKey, "ShowRecycleConfirmation", 0) = 0
    }
    
    static Enable()
    {
        try RegWrite 1, "REG_SZ", this.szKey, "ShowRecycleConfirmation"
    }
    
    static IsEnabled()
    {
        return RegRead(this.szKey, "ShowRecycleConfirmation", 0) = 1
    }
    
    static Toggle()
    {
        if this.IsEnabled()
            this.Disable
        else
            this.Enable
    }
}

class SHQUERYRBINFOEX extends SHQUERYRBINFO
{
    szSize
    {
        Get
        {
            try
                szSize := StrFormatByteSize(this.i64Size)
            catch
                szSize := NativeLanguage.szError
                
            return szSize
        }
    }
    
    szNumItems
    {
        Get
        {
            i64NumItems := this.i64NumItems
            
            return StrReplace(i64NumItems = 1
                              ? NativeLanguage.szItem
                              : NativeLanguage.szItems
                             ,"%s"
                             ,i64NumItems)
        }
    }
}

class TrayMenu
{
    static Load()
    {
        pSHStockIconInfo := SHSTOCKICONINFO()
        uFlags := SHGSI_ICON | SHGSI_SMALLICON
        
        SHGetStockIconInfo(SIID_ERROR, uFlags, pSHStockIconInfo)
        this.hIconError := pSHStockIconInfo.hIcon
        
        SHGetStockIconInfo(SIID_RECYCLER, uFlags, pSHStockIconInfo)
        this.hIconRecycler := pSHStockIconInfo.hIcon
        
        SHGetStockIconInfo(SIID_RECYCLERFULL, uFlags, pSHStockIconInfo)
        this.hIconRecyclerFull := pSHStockIconInfo.hIcon
        
        NativeLanguage.Load
        RunAtUserLogon.Load
        
        A_TrayMenu.Delete
        
        A_TrayMenu.Add "1", (*) => NULL
        A_TrayMenu.Add "2", (*) => NULL
        A_TrayMenu.Add
        A_TrayMenu.Add NativeLanguage.szRunAtUserLogon, (*) => RunAtUserLogon.Toggle()
        A_TrayMenu.Add NativeLanguage.szShowRecycleConfirmation, (*) => ShowRecycleConfirmation.Toggle()
        A_TrayMenu.Add
        A_TrayMenu.Add NativeLanguage.szOpen, (*) => RecycleBin.Open()
        A_TrayMenu.Add
        A_TrayMenu.Add NativeLanguage.szEmptyRecycleBin, (*) => RecycleBin.Empty()
        A_TrayMenu.Add
        A_TrayMenu.Add NativeLanguage.szHelp, (*) => this.Help()
        A_TrayMenu.Add
        A_TrayMenu.Add NativeLanguage.szClose, (*) => this.Close()
        
        WinSetExStyle NativeLanguage.bRTL ? +WS_EX_LAYOUTRTL : -WS_EX_LAYOUTRTL, A_ScriptHwnd
    
        NativeLanguage.DeleteProp "bRTL"
        NativeLanguage.DeleteProp "szClose"
        
        OnMessage AHK_NOTIFYICON, ObjBindMethod(this, "On_AHK_NOTIFYICON")
        OnMessage WM_INITMENUPOPUP, ObjBindMethod(this, "On_WM_INITMENUPOPUP")
        
        this.UpdateIcon
        SetTimer ObjBindMethod(this, "UpdateIcon"), 500
        
        A_IconHidden := false
        
        this.DeleteProp "Load"
    }
    
    static Close()
    {
        if GetKeyState("Ctrl")
            Reload
        else
            ExitApp
    }
    
    static Help()
    {
        try Run "https://github.com/warg0x4e/HotBin/issues"
    }
    
    static On_AHK_NOTIFYICON(wParam, lParam, *)
    {
        static bDoubleClicked := false
        
        MouseGetPos &uCoordX, &uCoordY
        
        switch lParam
        {
            case WM_LBUTTONUP:
            {
                if KeyWait("LButton", "DT" GetDoubleClickTime() / 1000)
                {
                    bDoubleClicked := true
                    
                    try
                        pSHQueryRBInfoEx := RecycleBin.Query()
                    catch
                        return 0
                        
                    if pSHQueryRBInfoEx.i64NumItems
                        RecycleBin.Empty
                }
                else if bDoubleClicked
                    bDoubleClicked := false
                else
                    A_TrayMenu.Show uCoordX, uCoordY
            }
            
            case WM_RBUTTONUP:
                    A_TrayMenu.Show uCoordX, uCoordY
            
            case WM_MBUTTONUP:
                RecycleBin.Open
        }
        
        return 0
    }
    
    static On_WM_INITMENUPOPUP(*)
    {
        this.UpdateMenu
        
        return 0
    }
    
    static SetCustomMenuItemIcon(szMenuItem, szIcon)
    {
        try
        {
            A_TrayMenu.SetIcon szMenuItem, LOCALAPPDATA "\HotBin\" szIcon
            return true
        }
        
        try
        {
            A_TrayMenu.SetIcon szMenuItem, szIcon
            return true
        }
        
        return false
    }
    
    static SetCustomTrayIcon(szIcon)
    {
        try
        {
            TraySetIcon LOCALAPPDATA "\HotBin\" szIcon
            return true
        }
        
        try
        {
            TraySetIcon szIcon
            return true
        }
        
        return false
    }
    
    static SetStockMenuItemIcon(szMenuItem, hIcon)
    {
        A_TrayMenu.SetIcon szMenuItem, "HICON:*" hIcon
    }
    
    static SetStockTrayIcon(hIcon)
    {
        TraySetIcon "HICON:*" hIcon
    }
    
    static UpdateIcon()
    {
        static i64PrevSize := -1
              ,i64PrevNumItems := -1
        
        try
            pSHQueryRBInfoEx := RecycleBin.Query()
        catch
        {
            A_IconTip := NativeLanguage.szError
            
            if !this.SetCustomTrayIcon("error.ico")
                TraySetIcon "HICON:*" this.hIconError
                
            return
        }
        
        i64Size := pSHQueryRBInfoEx.i64Size
        i64NumItems := pSHQueryRBInfoEx.i64NumItems
        
        if i64Size = i64PrevSize && i64NumItems = i64PrevNumItems
            ;// No change.
            return
            
        szSize := pSHQueryRBInfoEx.szSize
        szNumItems := pSHQueryRBInfoEx.szNumItems
            
        A_IconTip := szSize "`n" szNumItems
        
        if i64NumItems
        {
            if !this.SetCustomTrayIcon("full.ico")
                TraySetIcon "HICON:*" this.hIconRecyclerFull
        }
        else
        {
            if !this.SetCustomTrayIcon("empty.ico")
                TraySetIcon "HICON:*" this.hIconRecycler
        }
    }
    
    static UpdateMenu()
    {
        static i64PrevSize := -1
              ,i64PrevNumItems := -1
        
        if RunAtUserLogon.IsEnabled()
            A_TrayMenu.Check NativeLanguage.szRunAtUserLogon
        else
            A_TrayMenu.Uncheck NativeLanguage.szRunAtUserLogon
        
        if ShowRecycleConfirmation.IsEnabled()
            A_TrayMenu.Check NativeLanguage.szShowRecycleConfirmation
        else
            A_TrayMenu.Uncheck NativeLanguage.szShowRecycleConfirmation
        
        try
            pSHQueryRBInfoEx := RecycleBin.Query()
        catch
        {
            A_TrayMenu.Enable NativeLanguage.szEmptyRecycleBin
            A_TrayMenu.Rename "1&", NativeLanguage.szError
            A_TrayMenu.Rename "2&", NativeLanguage.szError
            
            if !this.SetCustomMenuItemIcon(NativeLanguage.szEmptyRecycleBin, "error.ico")
                A_TrayMenu.SetIcon NativeLanguage.szEmptyRecycleBin, "HICON:*" this.hIconError
                
            return
        }
        
        i64Size := pSHQueryRBInfoEx.i64Size
        i64NumItems := pSHQueryRBInfoEx.i64NumItems
        
        if i64Size = i64PrevSize && i64NumItems = i64PrevNumItems
            ;// No change.
            return
            
        szSize := pSHQueryRBInfoEx.szSize
        szNumItems := pSHQueryRBInfoEx.szNumItems
        
        A_TrayMenu.Rename "1&", szSize
        A_TrayMenu.Rename "2&", szNumItems
        
        if i64NumItems
        {
            A_TrayMenu.Enable NativeLanguage.szEmptyRecycleBin
            
            if !this.SetCustomMenuItemIcon(NativeLanguage.szEmptyRecycleBin, "full.ico")
                A_TrayMenu.SetIcon NativeLanguage.szEmptyRecycleBin, "HICON:*" this.hIconRecyclerFull
        }
        else
        {
            A_TrayMenu.Disable NativeLanguage.szEmptyRecycleBin
            
            if !this.SetCustomMenuItemIcon(NativeLanguage.szEmptyRecycleBin, "empty.ico")
                A_TrayMenu.SetIcon NativeLanguage.szEmptyRecycleBin, "HICON:*" this.hIconRecycler
        }
    }
}

IsWindows8OrGreater()
{
    dwlConditionMask := VerSetConditionMask(0
                                           ,VER_MAJORVERSION
                                           ,VER_GREATER_EQUAL)
    
    dwlConditionMask := VerSetConditionMask(dwlConditionMask
                                           ,VER_MINORVERSION
                                           ,VER_GREATER_EQUAL)
    
    pOSVersionInfoEx := OSVERSIONINFOEX()
    
    pOSVersionInfoEx.dwMajorVersion := 6
    pOSVersionInfoEx.dwMinorVersion := 2
    
    return VerifyVersionInfo(pOSVersionInfoEx
                            ,VER_MAJORVERSION | VER_MINORVERSION
                            ,dwlConditionMask)
}

RunAsInteractiveUser()
{
    if A_IsAdmin
    {
        if A_IsCompiled
            szCmdLine := '"' A_ScriptFullPath '"'
        else
            szCmdLine := '"' A_AhkPath '" "' A_ScriptFullPath '"'
        
        try WdcRunTaskAsInteractiveUser szCmdLine, A_ScriptDir
    }
        
    return !A_IsAdmin
}

WdcRunTaskAsInteractiveUser(pwszCmdLine, pwszPath)
{
    return DllCall("wdc\WdcRunTaskAsInteractiveUser"
                  ,"WStr", pwszCmdLine
                  ,"WStr", pwszPath
                  ,"UInt", 0
                  ,"HRESULT")
}

#Include WinApi\combaseapi\CLSIDFromString.ahk
#Include WinApi\combaseapi\CoTaskMemFree.ahk
#Include WinApi\guiddef\GUID.ahk
#Include WinApi\libloaderapi\FreeLibrary.ahk
#Include WinApi\libloaderapi\LoadLibrary.ahk
#Include WinApi\shellapi\SHEmptyRecycleBin.ahk
#Include WinApi\shellapi\SHGetStockIconInfo.ahk
#Include WinApi\shellapi\SHQUERYRBINFO.ahk
#Include WinApi\shellapi\SHQueryRecycleBin.ahk
#Include WinApi\shellapi\SHSTOCKICONINFO.ahk
#Include WinApi\shlobj_core\SHGetKnownFolderPath.ahk
#Include WinApi\shlwapi\StrFormatByteSize.ahk
#Include WinApi\synchapi\CreateMutex.ahk
#Include WinApi\winbase\VerifyVersionInfo.ahk
#Include WinApi\winnls\GetLocaleInfoEx.ahk
#Include WinApi\winnt\OSVERSIONINFOEX.ahk
#Include WinApi\winnt\VerSetConditionMask.ahk
#Include WinApi\winuser\GetDoubleClickTime.ahk
#Include WinApi\winuser\LoadString.ahk
