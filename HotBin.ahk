;@Ahk2Exe-Let AppVersion = 2.11.1.0
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

APP_NAME := "HotBin"

;// https://bit.ly/4cIb0e3
AHK_NOTIFYICON := 0x404

;// libloaderapi.h
LOAD_LIBRARY_AS_DATAFILE := 0x2

;// shellapi.h
SHERB_NOCONFIRMATION := 0x1
SHGSI_ICON := 0x100
SHGSI_SMALLICON := 0x1
SIID_RECYCLER := 31
SIID_RECYCLERFULL := 32

;// shlobj_core.h
KF_FLAG_DONT_VERIFY := 0x4000

;// winerror.h
ERROR_INVALID_CURSOR_HANDLE := 1402
ERROR_INVALID_DATA := 13
ERROR_NOT_SUPPORTED := 50
ERROR_OLD_WIN_VERSION := 1150
ERROR_SUCCESS := 0

;// winnt.h
EVENTLOG_ERROR_TYPE := 0x1

;// winuser.h
WM_INITMENUPOPUP := 0x117
WM_LBUTTONUP := 0x202
WM_MBUTTONUP := 0x208
WM_RBUTTONUP := 0x205
WS_EX_LAYOUTRTL := 0x400000

Main()
Main()
{
    ProcessSetPriority "Low"
    
    if A_IsAdmin
    {
        szCmdLine := A_IsCompiled
                     ? '"' A_ScriptFullPath '"'
                     : '"' A_AhkPath '" "' A_ScriptFullPath '"'
        
        try
            WdcRunTaskAsInteractiveUser szCmdLine, A_ScriptDir
        catch OSError as err
            LogError err
            
        ExitApp LogError(OSError(ERROR_NOT_SUPPORTED))
    }
    
    if !VerCompare(A_OSVersion, ">=6.2")
        ExitApp LogError(OSError(ERROR_OLD_WIN_VERSION))
        
    try CreateMutex NULL, false, "{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}"
    
    if A_LastError
        ExitApp LogError(OSError(A_LastError))
    
    global LOCALAPPDATA
    
    try
    {
        LOCALAPPDATA := SHGetKnownFolderPath("{F1B32785-6FBA-4FCF-9D55-7B8E7F157091}"
                                            ,KF_FLAG_DONT_VERIFY
                                            ,NULL)
        
        DirCreate LOCALAPPDATA "\" APP_NAME
    }
    catch OSError as err
    {
        LogError err
        LOCALAPPDATA := NONE
    }
    
    TrayMenu.Load
}

class Language
{
    static Load()
    {
        hMMRes := NULL
        hMSTask := NULL
        hShell32 := NULL
        
        try
        {
            hMMRes := LoadLibraryEx("mmres", NULL, LOAD_LIBRARY_AS_DATAFILE)
            hMSTask := LoadLibraryEx("mstask", NULL, LOAD_LIBRARY_AS_DATAFILE)
            hShell32 := LoadLibraryEx("shell32", NULL, LOAD_LIBRARY_AS_DATAFILE)
            
            this.bIsRTL := WinGetExStyle(WinWait("ahk_class Shell_TrayWnd")) & WS_EX_LAYOUTRTL
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
            LogError err
            this.bIsRTL := 0
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
        
        if hMMRes
            try
                FreeLibrary hMMRes
            catch OSError as err
                LogError err
                
        if hMSTask
            try
                FreeLibrary hMSTask
            catch OSError as err
                LogError err
                
        if hShell32
            try
                FreeLibrary hShell32
            catch OSError as err
                LogError err
        
        this.DeleteProp "Load"
    }
}

class RecycleBin
{
    static Empty()
    {
        if !this.Query().i64NumItems
            return
            
        dwFlags := ShowRecycleConfirmation.IsDisabled() || GetKeyState("Ctrl")
                   ? SHERB_NOCONFIRMATION
                   : NULL
        
        try
            SHEmptyRecycleBin A_ScriptHwnd, NONE, dwFlags
        catch OSError as err
            ExitApp LogError(err)
    }
    
    static Open()
    {
        try
            Run "shell:RecycleBinFolder"
        catch
            ExitApp LogError(OSError(A_LastError))
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
        this.Update
        
        this.DeleteProp "Load"
    }
    
    static Disable()
    {
        szRegKey := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
        
        try
            RegWrite "030000", "REG_BINARY", szRegKey, APP_NAME
        catch OSError as err
            LogError err
            
        this.Update
    }
    
    static IsDisabled()
    {
        return !this.IsEnabled()
    }
    
    static Enable()
    {
        szRegKey := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
        
        try
            RegWrite "020000", "REG_BINARY", szRegKey, APP_NAME
        catch OSError as err
            LogError err
            
        this.Update
    }
    
    static IsEnabled()
    {
        szRegKey := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
        
        return !Mod(SubStr(RegRead(szRegKey, APP_NAME, "02"), 2, 1), 2)
    }
    
    static Toggle()
    {
        if this.IsEnabled()
            this.Disable
        else
            this.Enable
    }
    
    static Update()
    {
        szCmdLine := A_IsCompiled
                     ? '"' A_ScriptFullPath '"'
                     : '"' A_AhkPath '" "' A_ScriptFullPath '"'
        
        szRegKey := "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
        
        try
            RegWrite szCmdLine, "REG_SZ", szRegKey, APP_NAME
        catch OSError as err
            LogError err
    }
}

class ShowRecycleConfirmation
{
    static Disable()
    {
        szRegKey := "HKCU\SOFTWARE\HotBin"
        
        try
            RegWrite 0, "REG_DWORD", szRegKey, this.Prototype.__Class
        catch OSError as err
            LogError err
    }
    
    static IsDisabled()
    {
        return !this.IsEnabled()
    }
    
    static Enable()
    {
        szRegKey := "HKCU\SOFTWARE\HotBin"
        
        try
            RegWrite 1, "REG_DWORD", szRegKey, this.Prototype.__Class
        catch OSError as err
            LogError err
    }
    
    static IsEnabled()
    {
        szRegKey := "HKCU\SOFTWARE\HotBin"
        
        return RegRead(szRegKey, this.Prototype.__Class, 1) & 1
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
    
    static Load()
    {
        szDirs := LOCALAPPDATA
                  ? [LOCALAPPDATA "\" APP_NAME, A_ScriptDir]
                  : [A_ScriptDir]
        
        for szDir in szDirs
        {
            Loop Files szDir "\empty.*"
            {
                if this.hIconRecycler
                    break
                    
                if !InStr("gif|ico|odd|png|tif|tiff", A_LoopFileExt)
                    continue
                
                hIconRecycler := LoadPicture(A_LoopFileFullPath, "Icon1", &uType)
                
                try
                    TraySetIcon "HICON:*" hIconRecycler
                catch
                {
                    err := OSError(ERROR_INVALID_DATA)
                    NotifyError A_LoopFileFullPath, err.Message
                    LogError err
                    
                    if hIconRecycler
                        try
                            DestroyIcon hIconRecycler
                        catch OSError as err
                            LogError err
                }
                else
                    this.hIconRecycler := hIconRecycler
            }
            
            Loop Files szDir "\full.*"
            {
                if this.hIconRecyclerFull
                    break
                    
                if !InStr("gif|ico|odd|png|tif|tiff", A_LoopFileExt)
                    continue
                    
                hIconRecyclerFull := LoadPicture(A_LoopFileFullPath, "Icon1", &uType)
                
                try
                    TraySetIcon "HICON:*" hIconRecyclerFull
                catch
                {
                    err := OSError(ERROR_INVALID_DATA)
                    NotifyError A_LoopFileFullPath, err.Message
                    LogError err
                    
                    if hIconRecyclerFull
                        try
                            DestroyIcon hIconRecyclerFull
                        catch OSError as err
                            LogError err
                }
                else
                    this.hIconRecyclerFull := hIconRecyclerFull
            }
        }
        
        shsii := SHSTOCKICONINFO()
        dwFlags := SHGSI_ICON | SHGSI_SMALLICON
        
        if !this.hIconRecycler
        {
            try
                SHGetStockIconInfo SIID_RECYCLER, dwFlags, shsii
            catch OSError as err
                ExitApp LogError(err)
            
            hIconRecycler := shsii.hIcon
            
            try
                TraySetIcon "HICON:*" hIconRecycler
            catch
                ExitApp LogError(OSError(ERROR_INVALID_CURSOR_HANDLE))
                
            this.hIconRecycler := hIconRecycler
        }
        
        if !this.hIconRecyclerFull
        {
            try
                SHGetStockIconInfo SIID_RECYCLERFULL, dwFlags, shsii
            catch OSError as err
                ExitApp LogError(err)
                
            hIconRecyclerFull := shsii.hIcon
            
            try
                TraySetIcon "HICON:*" hIconRecyclerFull
            catch
                ExitApp LogError(OSError(ERROR_INVALID_CURSOR_HANDLE))
                
            this.hIconRecyclerFull := hIconRecyclerFull
        }
        
        Language.Load
        RunAtUserLogon.Load
        
        A_TrayMenu.Delete
        
        A_TrayMenu.Add "1", (*) => NULL
        A_TrayMenu.Add "2", (*) => NULL
        A_TrayMenu.Add
        A_TrayMenu.Add Language.szRunAtUserLogon, (*) => RunAtUserLogon.Toggle()
        A_TrayMenu.Add Language.szShowRecycleConfirmation, (*) => ShowRecycleConfirmation.Toggle()
        A_TrayMenu.Add
        A_TrayMenu.Add Language.szOpen, (*) => RecycleBin.Open()
        A_TrayMenu.Add Language.szEmptyRecycleBin, (*) => RecycleBin.Empty()
        A_TrayMenu.Add
        A_TrayMenu.Add Language.szHelp, (*) => Run("https://github.com/warg0x4e/HotBin/issues")
        A_TrayMenu.Add Language.szClose, (*) => GetKeyState("Ctrl")
                                                ? Reload()
                                                : ExitApp()
        
        WinSetExStyle Language.bIsRTL
                      ? +WS_EX_LAYOUTRTL
                      : -WS_EX_LAYOUTRTL
                     ,A_ScriptHwnd
        
        Language.DeleteProp "bIsRTL"
        Language.DeleteProp "szClose"
        Language.DeleteProp "szHelp"
        Language.DeleteProp "szOPen"
        
        OnMessage AHK_NOTIFYICON, ObjBindMethod(this, "AHK_NOTIFYICON")
        OnMessage WM_INITMENUPOPUP, ObjBindMethod(this, "WM_INITMENUPOPUP")
        
        this.Loop
        SetTimer ObjBindMethod(this, "Loop")
        
        A_IconHidden := false
    }
    
    static AHK_NOTIFYICON(wParam, lParam, *)
    {
        MouseGetPos &x, &y
        
        switch lParam
        {
            case WM_LBUTTONUP: this.WM_LBUTTONUP x, y
            case WM_MBUTTONUP: this.WM_MBUTTONUP x, y
            case WM_RBUTTONUP: this.WM_RBUTTONUP x, y
        }
        
        return ERROR_SUCCESS
    }
    
    static WM_INITMENUPOPUP(*)
    {
        if RunAtUserLogon.IsEnabled()
            A_TrayMenu.Check Language.szRunAtUserLogon
        else
            A_TrayMenu.Uncheck Language.szRunAtUserLogon
        
        if ShowRecycleConfirmation.IsEnabled()
            A_TrayMenu.Check Language.szShowRecycleConfirmation
        else
            A_TrayMenu.Uncheck Language.szShowRecycleConfirmation
        
        shqrbi := RecycleBin.Query()
        
        i64Size := shqrbi.i64Size
        i64NumItems := shqrbi.i64NumItems
        
        szSize := StrFormatByteSize(i64Size)
        szNumItems := StrReplace(i64NumItems = 1
                                 ? Language.szItem
                                 : Language.szItems
                                ,"%s"
                                ,i64NumItems)
        
        A_TrayMenu.Rename "1&", szSize
        A_TrayMenu.Rename "2&", szNumItems
        
        if i64NumItems
        {
            A_TrayMenu.Enable Language.szEmptyRecycleBin
            
            try
                A_TrayMenu.SetIcon Language.szEmptyRecycleBin, "HICON:*" this.hIconRecyclerFull
            catch
                ExitApp LogError(OSError(ERROR_INVALID_CURSOR_HANDLE))
        }
        else
        {
            A_TrayMenu.Disable Language.szEmptyRecycleBin
            
            try
                A_TrayMenu.SetIcon Language.szEmptyRecycleBin, "HICON:*" this.hIconRecycler
            catch
                ExitApp LogError(OSError(ERROR_INVALID_CURSOR_HANDLE))
        }
        
        return ERROR_SUCCESS
    }
    
    static WM_LBUTTONUP(x, y)
    {
        if KeyWait("LButton", "DT" GetDoubleClickTime() / 1000)
            RecycleBin.Empty
        else
            A_TrayMenu.Show x, y
        
        KeyWait "LButton"
    }
    
    static WM_MBUTTONUP(x, y)
    {
        RecycleBin.Open
    }
    
    static WM_RBUTTONUP(x, y)
    {
        A_TrayMenu.Show x, y
    }
    
    static Loop()
    {
        static i64SizePrior := -1
              ,i64NumItemsPrior := -1
        
        shqrbi := RecycleBin.Query()
        
        i64Size := shqrbi.i64Size
        i64NumItems := shqrbi.i64NumItems
        
        if i64Size = i64SizePrior && i64NumItems = i64NumItemsPrior
            return
            
        i64SizePrior := i64Size
        i64NumItemsPrior := i64NumItems
        
        hIcon := i64NumItems
                 ? this.hIconRecyclerFull
                 : this.hIconRecycler
        
        try
            TraySetIcon "HICON:*" hIcon
        catch
            ExitApp LogError(OSError(ERROR_INVALID_CURSOR_HANDLE))
        
        szSize := StrFormatByteSize(i64Size)
        szNumItems := StrReplace(i64NumItems = 1
                                 ? Language.szItem
                                 : Language.szItems
                                ,"%s"
                                ,i64NumItems)
        
        A_IconTip := szSize "`n" szNumItems
    }
}

LogError(err)
{
    try
        hEventLog := RegisterEventSource(NONE, APP_NAME)
    catch
        return err.Number
        
    aStack := StrSplit(err.Stack, "`n")
    pStack := Buffer(A_PtrSize * aStack.Length)
    
    for i, sz in aStack
    {
        psz := Buffer(StrPut(sz))
        StrPut sz, psz
        aStack[i] := psz
        NumPut "Ptr", psz.Ptr, pStack, A_PtrSize * (i - 1)
    }
    
    try
    {
        ReportEvent hEventLog
                   ,EVENTLOG_ERROR_TYPE
                   ,NULL
                   ,err.Number
                   ,NULL
                   ,aStack.Length
                   ,NULL
                   ,pStack
                   ,NULL
        
        DeregisterEventSource(hEventLog)
    }
    
    return err.Number
}

NotifyError(szText, szTitle)
{
    SetTimer TrayTip.Bind(szText, szTitle, 3), -1000
}

WdcRunTaskAsInteractiveUser(szCmdLine, szWorkingDir)
{
    DllCall("wdc\WdcRunTaskAsInteractiveUser"
           ,"WStr", szCmdLine
           ,"WStr", szWorkingDir
           ,"UInt", NULL
           ,"HRESULT")
}

#Include %A_LineFile%\..\WinApi
#Include libloaderapi\FreeLibrary.ahk
#Include libloaderapi\LoadLibraryEx.ahk
#Include shellapi\SHEmptyRecycleBin.ahk
#Include shellapi\SHGetStockIconInfo.ahk
#Include shellapi\SHQUERYRBINFO.ahk
#Include shellapi\SHQueryRecycleBin.ahk
#Include shellapi\SHSTOCKICONINFO.ahk
#Include shlobj_core\SHGetKnownFolderPath.ahk
#Include shlwapi\StrFormatByteSize.ahk
#Include synchapi\CreateMutex.ahk
#Include winbase\DeregisterEventSource.ahk
#Include winbase\RegisterEventSource.ahk
#Include winbase\ReportEvent.ahk
#Include winuser\DestroyIcon.ahk
#Include winuser\GetDoubleClickTime.ahk
#Include winuser\LoadString.ahk
