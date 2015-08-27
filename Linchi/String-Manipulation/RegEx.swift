//
//  RegEx.swift
//  Linchi
//

import Darwin

internal struct RegEx {
    
    private let re : regex_t
    
    /// Initializes the regex using the given pattern. Will fail if the pattern is not a correct regex
    init?(_ pattern: String) {
        var regex = regex_t()
        guard regcomp(&regex, pattern, REG_EXTENDED) == 0 else { return nil }
        self.re = regex
    }
    
    /// Returns true iff the regex matches the entire given string
    func matches(string: String) -> Bool {
        var recopy = re
        var matches = Array<regmatch_t>(count: 1, repeatedValue: regmatch_t())
        guard regexec(&recopy, string, 1, &matches, 0) == 0 else { return false }
        let first = matches.first!
        return first.rm_eo - first.rm_so == string.utf8.count
    }
    
    /// Defines a character class that can be used in regular expressions.
    enum CharClass : CustomStringConvertible {
        /// Letters of the roman alphabet (a, b, ..., y, z, A, B, ..., Y, Z)
        case Alpha
        /// Digits (0, 1, ..., 8, 9)
        case Digits
        /// Letters of the roman alphabet or digits
        case AlphaNum
        /// Every visible unicode character, and ‘space’
        case Printable
        
        /// Corrsponding regex pattern, inside brackets.
        var description : String {
            switch self {
            case AlphaNum  : return "[a-zA-Z0-9]"
            case Alpha     : return "[a-zA-Z]"
            case Digits    : return "[0-9]"
            case Printable : return "[^\\p{Z}\\p{C}]"
            }
        }
    }
}


