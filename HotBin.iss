#define AppVersion "2.11.0.0"

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
CloseApplications=force
DefaultDirName={autopf}\HotBin
DefaultGroupName=HotBin
MinVersion=6.2
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline dialog
SetupMutex={{2273C7A2-14E1-4E90-9BAA-58C1C7A14DFA},Global\{{2273C7A2-14E1-4E90-9BAA-58C1C7A14DFA}
UninstallDisplayIcon={app}\HotBin.exe,0
UninstallDisplayName=HotBin
AppCopyright=The Unlicense
SetupIconFile=HotBin.ico
WizardStyle=modern
OutputBaseFilename=HotBin-{#AppVersion}-setup
OutputDir=.
SourceDir=.
VersionInfoVersion={#AppVersion}

[Dirs]


[Files]
Source: "HotBin-{#AppVersion}-x64.exe"; DestDir: "{app}"; DestName: "HotBin.exe"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "HotBin-{#AppVersion}-x86.exe"; DestDir: "{app}"; DestName: "HotBin.exe"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "empty.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "full.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; DestName: "LICENSE.txt"; Flags: ignoreversion
Source: "LICENSE.AutoHotkey"; DestDir: "{app}"; DestName: "LICENSE.AutoHotkey.txt"; Flags: ignoreversion

[Languages]
Name: "Default"; MessagesFile: "compiler:Default.isl"
Name: "Armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "Bulgarian"; MessagesFile: "compiler:Languages\Bulgarian.isl"
Name: "Catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "Corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "Czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "Danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "Dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "Finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "French"; MessagesFile: "compiler:Languages\French.isl"
Name: "German"; MessagesFile: "compiler:Languages\German.isl"
Name: "Hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "Hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "Icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "Italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "Japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "Norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "Polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "Portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "Russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "Slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "Slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "Spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "Turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "Ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Icons]
Name: "{group}\HotBin"; Filename: "{app}\HotBin.exe"

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueName: "HotBin"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"; ValueName: "HotBin"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "SOFTWARE\HotBin"; Flags: uninsdeletekey

[Run]
Filename: "{app}\HotBin.exe"; Flags: nowait postinstall skipifsilent
