#Requires AutoHotkey v2.0+

#Include ..
#Include combaseapi\CLSIDFromString.ahk
#Include combaseapi\StringFromCLSID.ahk
#Include winerror\const\E_ACCESSDENIED.ahk
#Include winerror\const\E_INVALIDARG.ahk

class GUID Extends Buffer
{
    static SIZE => 16
    
    Size
    {
        Set
        {
            throw OSError(E_ACCESSDENIED, -1, "Read-only.")
        }
    }
    
    iVariant => NumGet(this, 4, "UChar" ) >> 4
    iVersion => NumGet(this, 6, "UShort") >> 12
    
    static Call(args*)
    {
        guidInstance := super(16)
        ptr := guidInstance.Ptr
        
        switch args.Length
        {
            case 0:
            ;// GUID()
            NumPut("Int64", 0, "Int64", 0, guidInstance)
            
            case 1:
            ;// GUID("{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}")
            value := args[1]
            
            try
                CLSIDFromString(value, guidInstance)
            catch
                throw OSError(E_INVALIDARG, -1, value)
            
            case 11:
            ;// GUID(UInt, UShort, UShort, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar)
            loop 11
            {
                value := args[A_Index]
                
                if !IsInteger(value)
                    throw OSError(E_INVALIDARG, -1, value)
                    
                ptr := NumPut(A_Index > 3 ? "UChar" : A_Index > 1 ? "UShort" : "UInt", value, ptr)
            }
            
            case 16:
            ;// GUID(UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar, UChar))
            loop 16
            {
                value := args[A_Index]
                
                if !IsInteger(value)
                    throw OSError(E_INVALIDARG, -1, value)
                    
                ptr := NumPut("UChar", value, ptr)
            }
            
            DEFAULT:
            throw OSError(E_INVALIDARG, -1, args.Length)
        }
        
        return guidInstance
    }
    
    ToString() => StringFromCLSID(this)
}
