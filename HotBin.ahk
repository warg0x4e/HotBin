;@Ahk2Exe-Let AppVersion = 2.10.0.0
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

APP_ID := "{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}"
APP_NAME := "HotBin"
APP_SUPPORT_URL := "https://github.com/warg0x4e/HotBin/issues"

NONE := ""
NULL := 0

;// https://github.com/AutoHotkey/AutoHotkey/blob/v2.0/source/hook.h
AHK_NOTIFYICON := 0x404

;// shellapi.h
SHERB_NOCONFIRMATION := 0x1
SHGSI_ICON := 0x100
SHGSI_SMALLICON := 0x1
SIID_RECYCLER := 31
SIID_RECYCLERFULL := 32

;// shlobj_core.h
KF_FLAG_DONT_VERIFY := 0x4000

;// winerror.h
ERROR_INVALID_DATA := 13
ERROR_NOT_SUPPORTED := 50
ERROR_OLD_WIN_VERSION := 1150
ERROR_SUCCESS := 0

;// winnls.h
LOCALE_IREADINGLAYOUT := 0x70

;// winnt.h
EVENTLOG_ERROR_TYPE := 0x1

;// winuser.h
WM_INITMENUPOPUP := 0x117
WM_LBUTTONUP := 0x202
WM_MBUTTONUP := 0x208
WM_RBUTTONUP := 0x205
WS_EX_LAYOUTRTL := 0x400000

CMD_LINE := A_IsCompiled
           ? '"' A_ScriptFullPath '"'
           : '"' A_AhkPath '" "' A_ScriptFullPath '"'

ICON_RECYCLER := "empty.ico"
ICON_RECYCLERFULL := "full.ico"

LOCALAPPDATA := NULL

Main()
Main()
{
    try
    {
        if !IsWindows8OrGreater()
            throw OSError(ERROR_OLD_WIN_VERSION)
            
        if !RunAsInteractiveUser()
            throw OSError(ERROR_NOT_SUPPORTED)
            
        CreateMutex NULL, false, APP_ID
        
        if dwError := A_LastError
            throw OSError(dwError)
    }
    catch OSError as err
        ExitApp LogError(err)
        
    try
    {
        pclsid := CLSIDFromString("{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}", Buffer(16, NULL))
        
        global LOCALAPPDATA := SHGetKnownFolderPath(pclsid, KF_FLAG_DONT_VERIFY, NULL)
    }
    catch OSError as err
    {
        LogError(err)
        
        global LOCALAPPDATA := NULL
    }
    
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
            
            this.bRTL := GetLocaleInfoEx(NULL, LOCALE_IREADINGLAYOUT) == 1
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
        catch OSError as err
        {
            LogError(err)
            
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
            try
                FreeLibrary hMMRes
            catch OSError as err
                LogError(err)
                
        if IsSet(hMSTask)
            try
                FreeLibrary hMSTask
            catch OSError as err
                LogError(err)
                
        if IsSet(hShell32)
            try
                FreeLibrary hShell32
            catch OSError as err
                LogError(err)
        
        this.DeleteProp "Load"
    }
}

class RecycleBin
{
    static Empty()
    {
        if !this.Query().i64NumItems
            return ERROR_SUCCESS
            
        dwFlags := ShowRecycleConfirmation.IsDisabled() || GetKeyState("Ctrl")
                   ? SHERB_NOCONFIRMATION
                   : NULL
        
        try
            SHEmptyRecycleBin NULL, NONE, dwFlags
        catch OSError as err
            ExitApp LogError(err)
            
        return ERROR_SUCCESS
    }
    
    static Open()
    {
        try
            Run "shell:RecycleBinFolder"
        catch
            ExitApp LogError(OSError(A_LastError))
            
        return ERROR_SUCCESS
    }
    
    static Query()
    {
        static shqrbi := SHQUERYRBINFO()
        
        try
            SHQueryRecycleBin NONE, shqrbi
        catch OSError as err
            ExitApp LogError(err)
            
        return shqrbi
    }
}

class RunAtUserLogon
{
    static Load()
    {
        if !this.IsEnabled()
            this.Disable
            
        this.DeleteProp "Load"
    }
    
    static Disable()
    {
        try
        {
            RegWrite "030000"
                    ,"REG_BINARY"
                    ,"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
                    ,APP_NAME
            
            RegWrite CMD_LINE
                    ,"REG_SZ"
                    ,"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                    ,APP_NAME
        }
        catch OSError as err
        {
            LogError(err)
            
            return err.Number
        }
        
        return ERROR_SUCCESS
    }
    
    static IsDisabled()
    {
        szApproved := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
                             ,APP_NAME
                             ,"02")
        
        szCmdLine := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                            ,APP_NAME
                            ,NONE)
        
        return Mod(SubStr(szApproved, 2, 1), 2) == 1 || szCmdLine != CMD_LINE
    }
    
    static Enable()
    {
        try
        {
            RegWrite "020000"
                    ,"REG_BINARY"
                    ,"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
                    ,APP_NAME
            
            RegWrite CMD_LINE
                    ,"REG_SZ"
                    ,"HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                    ,APP_NAME
        }
        catch OSError as err
        {
            LogError(err)
            
            return err.Number
        }
        
        return ERROR_SUCCESS
    }
    
    static IsEnabled()
    {
        szApproved := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
                             ,APP_NAME
                             ,"02")
        
        szCmdLine := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
                            ,APP_NAME
                            ,NONE)
        
        return Mod(SubStr(szApproved, 2, 1), 2) == 0 && szCmdLine == CMD_LINE
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
    static Disable()
    {
        try
            RegWrite 0
                    ,"REG_DWORD"
                    ,"HKCU\SOFTWARE\HotBin"
                    ,"ShowRecycleConfirmation"
        catch OSError as err
        {
            LogError(err)
            
            return err.Number
        }
        
        return ERROR_SUCCESS
    }
    
    static IsDisabled()
    {
        return RegRead("HKCU\SOFTWARE\HotBin"
                      ,"ShowRecycleConfirmation"
                      ,1) == 0
    }
    
    static Enable()
    {
        try
            RegWrite 1
                    ,"REG_DWORD"
                    ,"HKCU\SOFTWARE\HotBin"
                    ,"ShowRecycleConfirmation"
        catch OSError as err
        {
            LogError(err)
            
            return err.Number
        }
        
        return ERROR_SUCCESS
    }
    
    static IsEnabled()
    {
        return RegRead("HKCU\SOFTWARE\HotBin"
                      ,"ShowRecycleConfirmation"
                      ,1) != 0
    }
    
    static Toggle()
    {
        if this.IsEnabled()
            this.Disable
        else
            this.Enable
    }
}

class TrayMenu
{
    static hIconRecycler := NULL
          ,hIconRecyclerFull := NULL
          ,i64Size := -1
          ,i64NumItems := -1
    
    static Load()
    {
        shsii := SHSTOCKICONINFO()
        dwFlags := SHGSI_ICON | SHGSI_SMALLICON
        
        Loop Parse, LOCALAPPDATA "\HotBin|" A_ScriptDir, "|"
        {
            hIcon := NULL
            szIcon := A_LoopField "\" ICON_RECYCLER
            
            if !this.hIconRecycler && FileExist(szIcon)
            {
                hIcon := LoadPicture(szIcon, "Icon1", &uType)
                
                try
                {
                    TraySetIcon "HICON:*" hIcon
                    
                    this.hIconRecycler := hIcon
                }
                catch
                {
                    LogError(OSError(ERROR_INVALID_DATA))
                    
                    try DestroyIcon(hIcon)
                }
            }
            
            hIcon := NULL
            szIcon := A_LoopField "\" ICON_RECYCLERFULL
            
            if !this.hIconRecyclerFull && FileExist(szIcon)
            {
                hIcon := LoadPicture(szIcon, "Icon1", &uType)
                
                try
                {
                    TraySetIcon "HICON:*" hIcon
                    
                    this.hIconRecyclerFull := hIcon
                }
                catch
                {
                    LogError(OSError(ERROR_INVALID_DATA))
                    
                    try DestroyIcon(hIcon)
                }
            }
        }
        
        if !this.hIconRecycler
        {
            try
                SHGetStockIconInfo(SIID_RECYCLER, dwFlags, shsii)
            catch OSError as err
                ExitApp LogError(err)
            
            hIcon := shsii.hIcon
            
            try
            {
                TraySetIcon "HICON:*" hIcon
                
                this.hIconRecycler := hIcon
            }
            catch
                ExitApp LogError(OSError(ERROR_INVALID_DATA))
        }
        
        if !this.hIconRecyclerFull
        {
            try
                SHGetStockIconInfo(SIID_RECYCLERFULL, dwFlags, shsii)
            catch OSError as err
                ExitApp LogError(err)
            
            hIcon := shsii.hIcon
            
            try
            {
                TraySetIcon "HICON:*" hIcon
                
                this.hIconRecyclerFull := hIcon
            }
            catch
                ExitApp LogError(OSError(ERROR_INVALID_DATA))
        }
        
        NativeLanguage.Load
        RunAtUserLogon.Load
        
        bRTL := NativeLanguage.bRTL
        szClose := NativeLanguage.szClose
        szEmptyRecycleBin := NativeLanguage.szEmptyRecycleBin
        szHelp := NativeLanguage.szHelp
        szOpen := NativeLanguage.szOpen
        szRunAtUserLogon := NativeLanguage.szRunAtUserLogon
        szShowRecycleConfirmation := NativeLanguage.szShowRecycleConfirmation
        
        NativeLanguage.DeleteProp "bRTL"
        NativeLanguage.DeleteProp "szClose"
        NativeLanguage.DeleteProp "szHelp"
        NativeLanguage.DeleteProp "szOpen"
        
        A_TrayMenu.Delete
        
        A_TrayMenu.Add "1", (*) => NULL
        A_TrayMenu.Add "2", (*) => NULL
        
        A_TrayMenu.Add ;// Separator.
        A_TrayMenu.Add szRunAtUserLogon, (*) => RunAtUserLogon.Toggle()
        A_TrayMenu.Add szShowRecycleConfirmation, (*) => ShowRecycleConfirmation.Toggle()
        A_TrayMenu.Add ;// Separator.
        A_TrayMenu.Add szOpen, (*) => RecycleBin.Open()
        A_TrayMenu.Add szEmptyRecycleBin, (*) => RecycleBin.Empty()
        A_TrayMenu.Add ;// Separator.
        A_TrayMenu.Add szHelp, (*) => Run(APP_SUPPORT_URL)
        A_TrayMenu.Add szClose, (*) => GetKeyState("Ctrl")
                                       ? Reload()
                                       : ExitApp()
        
        WinSetExStyle bRTL
                      ? +WS_EX_LAYOUTRTL
                      : -WS_EX_LAYOUTRTL
                     ,A_ScriptHwnd
        
        OnMessage AHK_NOTIFYICON
                 ,ObjBindMethod(this, "AHK_NOTIFYICON")
                 
        OnMessage WM_INITMENUPOPUP
                 ,ObjBindMethod(this, "WM_INITMENUPOPUP")
        
        this.Loop
        SetTimer ObjBindMethod(this, "Loop"), 500
        
        A_IconHidden := false
        
        this.DeleteProp "Load"
    }
    
    static AHK_NOTIFYICON(wParam, lParam, *)
    {
        MouseGetPos &iMouseX, &iMouseY
        
        switch lParam
        {
            case WM_LBUTTONUP: this.WM_LBUTTONUP iMouseX, iMouseY
            case WM_MBUTTONUP: this.WM_MBUTTONUP iMouseX, iMouseY
            case WM_RBUTTONUP: this.WM_RBUTTONUP iMouseX, iMouseY
        }
        
        return ERROR_SUCCESS
    }
    
    static WM_INITMENUPOPUP(*)
    {
        szItem := NativeLanguage.szItem
        szItems := NativeLanguage.szItems
        szEmptyRecycleBin := NativeLanguage.szEmptyRecycleBin
        szRunAtUserLogon := NativeLanguage.szRunAtUserLogon
        szShowRecycleConfirmation := NativeLanguage.szShowRecycleConfirmation
        
        if RunAtUserLogon.IsEnabled()
            A_TrayMenu.Check szRunAtUserLogon
        else
            A_TrayMenu.Uncheck szRunAtUserLogon
        
        if ShowRecycleConfirmation.IsEnabled()
            A_TrayMenu.Check szShowRecycleConfirmation
        else
            A_TrayMenu.Uncheck szShowRecycleConfirmation
        
        shqrbi := RecycleBin.Query()
        
        i64Size := shqrbi.i64Size
        i64NumItems := shqrbi.i64NumItems
        
        if i64NumItems
        {
            A_TrayMenu.Enable szEmptyRecycleBin
            A_TrayMenu.SetIcon szEmptyRecycleBin, "HICON:*" this.hIconRecyclerFull
        }
        else
        {
            A_TrayMenu.Disable szEmptyRecycleBin
            A_TrayMenu.SetIcon szEmptyRecycleBin, "HICON:*" this.hIconRecycler
        }
        
        szSize := StrFormatByteSize(i64Size)
        szNumItems := StrReplace(i64NumItems == 1
                                 ? szItem
                                 : szItems
                                ,"%s"
                                ,i64NumItems)
        
        A_TrayMenu.Rename "1&", szSize
        A_TrayMenu.Rename "2&", szNumItems
        
        return ERROR_SUCCESS
    }
    
    static WM_LBUTTONUP(iMouseX, iMouseY)
    {
        if KeyWait("LButton", "DT" GetDoubleClickTime() / 1000)
        {
            RecycleBin.Empty
            
            KeyWait("LButton")
        }
        else
            A_TrayMenu.Show iMouseX, iMouseY
    }
    
    static WM_MBUTTONUP(iMouseX, iMouseY)
    {
        RecycleBin.Open
    }
    
    static WM_RBUTTONUP(iMouseX, iMouseY)
    {
        A_TrayMenu.Show iMouseX, iMouseY
    }
    
    static Loop()
    {
        static hIconRecycler := this.hIconRecycler
              ,hIconRecyclerFull := this.hIconRecyclerFull
              ,szItem := NativeLanguage.szItem
              ,szItems := NativeLanguage.szItems
        
        shqrbi := RecycleBin.Query()
        
        i64Size := shqrbi.i64Size
        i64NumItems := shqrbi.i64NumItems
        
        if i64Size == this.i64Size && i64NumItems == this.i64NumItems
            return
        
        this.i64Size := i64Size
        this.i64NumItems := i64NumItems
        
        hIcon := i64NumItems
                 ? hIconRecyclerFull
                 : hIconRecycler
                 
        TraySetIcon "HICON:*" hIcon
            
        szSize := StrFormatByteSize(i64Size)
        szNumItems := StrReplace(i64NumItems == 1
                                 ? szItem
                                 : szItems
                                ,"%s"
                                ,i64NumItems)
        
        A_IconTip := szSize "`n" szNumItems
    }
}

LogError(err)
{
    aStack := StrSplit(err.Stack, "`n")
    lpStrings := Buffer(A_PtrSize * aStack.Length, NULL)
    
    for i, szString in aStack
    {
        pString := Buffer(StrPut(szString, "UTF-16"), NULL)
        StrPut szString, pString, "UTF-16"
        aStack[i] := pString
        NumPut "Ptr", pString.Ptr, lpStrings, A_PtrSize * (i - 1)
    }
    
    try
    {
        hEventLog := RegisterEventSource(NONE, APP_NAME)
        
        ReportEvent hEventLog
                   ,EVENTLOG_ERROR_TYPE
                   ,NULL
                   ,err.Number
                   ,NULL
                   ,lpStrings
                   ,NULL
        
        DeregisterEventSource(hEventLog)
    }
    
    return err.Number
}

RunAsInteractiveUser()
{
    if A_IsAdmin
        WdcRunTaskAsInteractiveUser CMD_LINE, A_ScriptDir
    
    return !A_IsAdmin
}

WdcRunTaskAsInteractiveUser(pwszCmdLine, pwszPath)
{
    if HRESULT := DllCall("wdc\WdcRunTaskAsInteractiveUser"
                         ,"WStr", pwszCmdLine
                         ,"WStr", pwszPath
                         ,"UInt", 0
                         ,"Int")
        
        throw OSError(A_LastError, A_ThisFunc, HRESULT)
        
    return HRESULT
}

#Include %A_LineFile%\..\WinApi
#Include combaseapi\CLSIDFromString.ahk
#Include libloaderapi\FreeLibrary.ahk
#Include libloaderapi\LoadLibrary.ahk
#Include shellapi\SHEmptyRecycleBin.ahk
#Include shellapi\SHGetStockIconInfo.ahk
#Include shellapi\SHQUERYRBINFO.ahk
#Include shellapi\SHQueryRecycleBin.ahk
#Include shellapi\SHSTOCKICONINFO.ahk
#Include shlobj_core\SHGetKnownFolderPath.ahk
#Include shlwapi\StrFormatByteSize.ahk
#Include synchapi\CreateMutex.ahk
#Include versionhelpers\IsWindows8OrGreater.ahk
#Include versionhelpers\IsWindowsVersionOrGreater.ahk
#Include winbase\DeregisterEventSource.ahk
#Include winbase\RegisterEventSource.ahk
#Include winbase\ReportEvent.ahk
#Include winnls\GetLocaleInfoEx.ahk
#Include winuser\DestroyIcon.ahk
#Include winuser\GetDoubleClickTime.ahk
#Include winuser\LoadString.ahk