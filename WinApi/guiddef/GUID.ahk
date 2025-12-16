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
    
    iVariant => NumGet(this, 4, "UChar" ) >> 4
    iVersion => NumGet(this, 6, "UShort") >> 12
    
    __New(szGUIDOrProgID?)
    {
        super.__New(GUID.SIZE, 0)
        
        if IsSet(szGUIDOrProgID)
            try
                CLSIDFromString(szGUIDOrProgID, this)
            catch OSError as err
                throw OSError(err.Number, HERE)
    }
    
    ToString() => StringFromCLSID(this)
}
