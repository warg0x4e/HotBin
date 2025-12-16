#Requires AutoHotkey v2.0+

E_ACCESSDENIED(sz?, i:=-1) => OSError(0x80070005, --i, sz?)
