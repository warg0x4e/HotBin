#Requires AutoHotkey v2.0+

#Include ..
#Include const\HERE.ahk
#Include winerror\const\E_ACCESSDENIED.ahk
#Include winerror\const\E_INVALIDARG.ahk

class FILETIME Extends Buffer
{
    static SIZE => 8
    
    SIZE
    {
        Set
        {
            throw OSError(E_ACCESSDENIED, HERE)
        }
    }
    
    dwLowDateTime
    {
        Get => NumGet(this, 0, "UInt")
        
        Set
        {
            if !IsInteger(value)
                throw OSError(E_INVALIDARG, HERE)
                
            NumPut("UInt", value, this, 0)
            
            return value
        }
    }
    
    dwHighDateTime
    {
        Get => NumGet(this, 4, "UInt")
        
        Set
        {
            if !IsInteger(value)
                throw OSError(E_INVALIDARG, HERE)
                
            NumPut("UInt", value, this, 4)
            
            return value
        }
    }
    
    __New() => super.__New(FILETIME.SIZE, 0)
}
