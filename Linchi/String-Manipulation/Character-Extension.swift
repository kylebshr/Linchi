//
//  Character-Extension
//  Linchi
//

extension Character {

    /** Returns the ASCII value of `self`
    
    __precondition__: self is an ASCII character
    */
    internal func toASCII() -> UInt8 { return String(self).utf8.first! }
}

