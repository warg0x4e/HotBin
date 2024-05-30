#define AppVersion "2.7.15.0"

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

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "hy"; MessagesFile: "compiler:Armenian.isl"
Name: "bg"; MessagesFile: "compiler:Bulgarian.isl"
Name: "ca"; MessagesFile: "compiler:Catalan.isl"
Name: "co"; MessagesFile: "compiler:Corsican.isl"
Name: "cs"; MessagesFile: "compiler:Czech.isl"
Name: "da"; MessagesFile: "compiler:Danish.isl"
Name: "nl"; MessagesFile: "compiler:Dutch.isl"
Name: "fi"; MessagesFile: "compiler:Finnish.isl"
Name: "fr"; MessagesFile: "compiler:French.isl"
Name: "de"; MessagesFile: "compiler:German.isl"
Name: "he"; MessagesFile: "compiler:Hebrew.isl"
Name: "hu"; MessagesFile: "compiler:Hungarian.isl"
Name: "is"; MessagesFile: "compiler:Icelandic.isl"
Name: "it"; MessagesFile: "compiler:Italian.isl"
Name: "ja"; MessagesFile: "compiler:Japanese.isl"
Name: "no"; MessagesFile: "compiler:Norwegian.isl"
Name: "pl"; MessagesFile: "compiler:Polish.isl"
Name: "pt"; MessagesFile: "compiler:Portuguese.isl"
Name: "ru"; MessagesFile: "compiler:Russian.isl"
Name: "sk"; MessagesFile: "compiler:Slovak.isl"
Name: "sl"; MessagesFile: "compiler:Slovenian.isl"
Name: "es"; MessagesFile: "compiler:Spanish.isl"
Name: "tr"; MessagesFile: "compiler:Turkish.isl"
Name: "uk"; MessagesFile: "compiler:Ukrainian.isl"

[Icons]
Name: "{group}\HotBin"; Filename: "{app}\HotBin.exe"

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueName: "HotBin"; Flags: uninsdeletevalue

[Run]
Filename: "{app}\HotBin.exe"; Description: "Run HotBin"; Flags: nowait postinstall skipifsilent
Filename: "{app}\HotBin.exe"; Parameters: "/RunAtStartup"; Description: "Run HotBin at startup"; Flags: nowait postinstall skipifsilent
