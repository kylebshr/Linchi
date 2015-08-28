//
//  Percent-Encoding.swift
//  Linchi
//

extension UInt8 {
    
    // TODO: find better name than "hexNumber"
    /**
    Returns:
    - (0, 1, ..., 14, 15) iff input is ASCII value for (0, 1, ..., E, F)
    - `nil` otherwise
    */
    private static func hexNumber(asciiValue: UInt8) -> UInt8? {
        
        guard asciiValue >= 48 else { return nil }
        
        if asciiValue <= 57 {
            return asciiValue - 48
        }
        else if asciiValue >= 65 && asciiValue <= 70 {
            return asciiValue - 55
        }
        else if asciiValue >= 97 && asciiValue <= 102 {
            return asciiValue - 87
        }
        else {
            return nil
        }
    }
    
    /** 
    Returns the value of the hexadecimal number `"0x(fst)(snd)"` if `fst` and `snd`
    are ASCII values for hexadecimal digits. Returns nil otherwise.
    
    __Example__:
    
    `let fst = 67 // 'C'`

    `let snd = 50 // '2'`
    
    `// UInt8.fromHexRepresentation(fst, snd) == 194`
    */
    private static func fromHexRepresentation(fst: UInt8, _ snd: UInt8) -> UInt8? {
        guard let c1 = UInt8.hexNumber(fst), let c2 = UInt8.hexNumber(snd) else { return nil }
        return (c1 << 4) | c2
    }
    
    /** 
    Split `self` into its four left and right bits.
    
    __Example__:
    
    `0b00101110 -> 0b0010 and 0b1110`
    */
    private var split : (UInt8, UInt8) {
        return (self / 16, self % 16)
    }
    
    /// Percent-encode (`self` as a UTF-8 character).
    private func percentEncoding() -> String {
        return "%" + String.HEX_TABLE[Int(split.0)] + String.HEX_TABLE[Int(split.1)]
    }
}


extension String {
    
    private static func initReservedCharacters() -> [Bool] {
        var chars = [Bool](count: 127, repeatedValue: false)
        ["!", "#","$", "&", "'", "(", ")", "*", "+", "/", ":", ";", "=", "?", "@", "[", "]", "]", "%", ","].forEach { chars[Int(Character($0).toASCII())] = true }
        return chars
    }

    /// Reserved characters according to RFC 3986 Section 2.2. These characters have to be percent-encoded.
    private static let RESERVED_CHARS = String.initReservedCharacters()
    private static let HEX_TABLE = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
    
    /// Creates a String from the percent-encoded UTF-8 string `bytes`. (RFC 3986 Section 2.5)
    public func newByRemovingPercentEncoding() -> String {
        let percent = Character("%").toASCII()
        var result : [UInt8] = []
        var gen = utf8.generate()
        
        while let fst = gen.next() {

            guard fst == percent else {
                result.append(fst)
                continue
            }

            guard let snd = gen.next() else {
                result.append(fst)
                break
            }
            guard let thrd = gen.next() else {
                result.append(fst); result.append(snd)
                break
            }

            guard let value = UInt8.fromHexRepresentation(snd, thrd) else {
                result.append(fst); result.append(snd); result.append(thrd)
                continue
            }
            
            result.append(value)

        }
        return String.fromUTF8Bytes(result)
    }
    
    /// Creates a String equal to `self` percent-encoded.
    public func newByAddingPercentEncoding() -> String {
        return utf8.reduce("") {
            if $1 > 127 || String.RESERVED_CHARS[Int($1)] {
                return $0 + $1.percentEncoding()
            }
            else {
                return $0 + String(UnicodeScalar($1))
            }
        }
    }

}

