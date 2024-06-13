#define AppVersion "2.9.1.0"

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
MinVersion=6.3
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

[Files]
Source: "HotBin-{#AppVersion}-x64.exe"; DestDir: "{app}"; DestName: "HotBin.exe"; Check: Is64BitInstallMode; Flags: ignoreversion; BeforeInstall: TaskKill()
Source: "HotBin-{#AppVersion}-x86.exe"; DestDir: "{app}"; DestName: "HotBin.exe"; Check: not Is64BitInstallMode; Flags: ignoreversion; BeforeInstall: TaskKill()
Source: "LICENSE"; DestDir: "{app}"; DestName: "LICENSE.txt"; Flags: ignoreversion

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "hy"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "bg"; MessagesFile: "compiler:Languages\Bulgarian.isl"
Name: "ca"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "co"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "cs"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "da"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "fi"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "he"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hu"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "is"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "ja"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "no"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "sk"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "sl"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "tr"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "uk"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Icons]
Name: "{group}\HotBin"; Filename: "{app}\HotBin.exe"

[Registry]
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueName: "HotBin"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"; ValueName: "HotBin"; Flags: uninsdeletevalue

[Run]
Filename: "{app}\HotBin.exe"; Flags: nowait postinstall skipifsilent
