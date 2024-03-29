#define AppVersion "2.7.1.5"

[Setup]
AppComments=Easily access the Recycle Bin from the System Tray.
AppContact=https://github.com/warg0x4e/HotBin/issues
AppId={{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}
AppMutex={{9271AC2E-FC8B-489F-8F44-4D41A12E7C04},Global\{{9271AC2E-FC8B-489F-8F44-4D41A12E7C04}
AppName=HotBin
AppPublisher=warg0x4e
AppPublisherURL=https://github.com/warg0x4e/HotBin
AppSupportURL=https://github.com/warg0x4e/HotBin/issues
AppUpdatesURL=https://github.com/warg0x4e/HotBin/releases
AppVersion={#AppVersion}
ArchitecturesInstallIn64BitMode=x64
DefaultDirName={autopf}\HotBin
DefaultGroupName=HotBin
LicenseFile=LICENSE
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline dialog
SetupMutex=HotBinSetupMutex,Global\HotBinSetupMutex
UninstallDisplayIcon={app}\HotBin.exe,0
UninstallDisplayName=HotBin
AppCopyright=The Unlicense
SetupIconFile=HotBin.ico
WizardStyle=modern
OutputBaseFilename=HotBin-{#AppVersion}-setup
OutputDir=.
SourceDir=.
VersionInfoVersion={#AppVersion}

[Files]
Source: "HotBin-{#AppVersion}-x64.exe"; DestDir: "{app}"; DestName: "HotBin.exe"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "HotBin-{#AppVersion}-x86.exe"; DestDir: "{app}"; DestName: "HotBin.exe"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\HotBin"; Filename: "{app}\HotBin.exe"

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueName: "HotBin"; Flags: uninsdeletevalue

[Run]
Filename: "{app}\HotBin.exe"; Description: "Run HotBin"; Flags: nowait postinstall skipifsilent
Filename: "{app}\HotBin.exe"; Parameters: "/RunAtStartup"; Description: "Run HotBin at startup"; Flags: nowait postinstall skipifsilent
