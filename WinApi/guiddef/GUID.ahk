#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include combaseapi\CLSIDFromString.ahk
#Include combaseapi\StringFromCLSID.ahk
#Include winerror\const\E_ACCESSDENIED.ahk

class GUID Extends Buffer
{
    static SIZE => 16
    
    SIZE
    {
        Set
        {
            throw OSError(E_ACCESSDENIED, HERE)
        }
    }
    
    __New(szCLSIDOrProgID?)
    {
        if IsSet(szCLSIDOrProgID)
        {
            super.__New(16)
            
            try
                CLSIDFromString(szCLSIDOrProgID, this)
            catch OSError as err
                throw OSError(err.Number, HERE)
        }
        else
            super.__New(16, 0x00)
    }
    
    ToString() => StringFromCLSID(this)
}
