//
//  String-Extension.swift
//  Linchi
//

import Darwin

extension String {
    
    /// Returns the same string with every character from `chars` removed
    internal func newByTrimmingCharactersContainedInString(chars: String) -> String {
        return String(characters.filter { !chars.contains($0) })
    }
    
    /// Returns the same string with the first `n` characters removed
    internal func removeFirst(n: Int = 1) -> String {
        return String(characters.dropFirst(n))
    }
    
    /// Returns the maximal substrings of `self`, in order, around a separator character.
    internal func split(c: Character) -> [String] {
        return characters.split(c).map(String.init)
    }

    /// Returns the two maximal substrings of `self`, in order, around the first occurence of a separator character
    internal func splitOnce(c: Character) -> (String, String)? {
        guard let index = characters.indexOf(c) else { return nil }
        return (
            String(characters.prefixUpTo(index)),
            String(characters.suffixFrom(index.successor()))
        )
    }
    
    /// Returns `true` iff the character `c` is present in `self`
    internal func contains(c: Character) -> Bool {
        return characters.contains(c)
    }
    
    /// Returns the UTF8 representation of `self`
    public func toUTF8Bytes() -> [UInt8] {
        return utf8.map{$0}
    }

    /// Returns a copy of `self`, except all instances of "+" have been replaced by " " (space) 
    internal func newByReplacingPlusesBySpaces() -> String {
        var bytes = ""
        for c in characters {
            if c == "+" { bytes.append(Character(" ")) }
            else { bytes.append(c) }
        }
        return bytes
    }
    
    /// Creates a String from an array of bytes, assuming an UTF-8 encoding
    internal static func fromUTF8Bytes(bytes: [UInt8]) -> String {
        var gen = bytes.generate()
        var str = ""
        var x = UTF8()
        loop: while true {
            let z = x.decode(&gen)
            switch z {
            case .Result(let unicodeScalar):
                if unicodeScalar.value == 0 { break }
                str.append(unicodeScalar)
            case .Error:
                // print("Error when decoding string.")
                continue loop
            case .EmptyInput:
                break loop
            }
        }
        return str
    }
}

