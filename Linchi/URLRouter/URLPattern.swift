//
//  URLPattern.swift
//  Linchi
//

/**
Describes a component of a `URLPattern`. Either raw text or regex.

__Example:__

The url `"users/∆: [a-zA-Z]+/profile/"`

will be represented as an array of these `URLPatternElement`: 

`[Text("users"), Regex("[a-zA-Z]+"), Text("profile")]`

Because the urls are separated by "/", the regexes or raw strings
CANNOT contain any "/".
*/
private enum URLPatternElement {
    case Text(String)
    case Parameter(name: String, pattern: RegEx)
    
    /// Returns true iff the given string matches the text or regex
    func matches(s: String) -> Bool {
        switch self {
        case .Text(let text)       : return text == s
        case .Parameter(_, let regex): return regex.matches(s)
        }
    }
}

/** 
A URLPattern is a set of URL capable of capturing parameters.

__Example__

`let urlPattern = URLPattern("users/∆: name=[a-zA-Z]+/profile")`

`let match = urlPattern.matches("users/anna/profile")`

`// match.0 == true; match.1 == ["name": "anna"]`

__Rules for the initialization string:__

- Trailing or leading slashes don't matter
- Between slashes, there is either:
    - raw text
    - a regex prefixed by "∆: " (with a trailing space!)
- No slashes in the regex
*/
internal struct URLPattern {

    private let elements : [URLPatternElement]

    internal init?(str: String) {
        
        var tmpPattern = [URLPatternElement]()
        let components = str.split("/")

        for component in components {
            if component.hasPrefix("∆: ") {
                let withoutDelta = component.removeFirst(3)
                guard let (name, regexString) = withoutDelta.splitOnce("=") else { return nil }
                guard let reg = RegEx(regexString) else { return nil }
                tmpPattern.append(.Parameter(name: name, pattern: reg))
            }
            else {
                tmpPattern.append(.Text(component))
            }
        }

        self.elements = tmpPattern
    }
    
    /** Returns:
    
    `(true, params)` iff the given url matches the URLPattern
    
    `(false, nil)` otherwise
    */
    internal func matches(url: String) -> (matches: Bool, params: [String: String]) {
        
        let split1 = url.splitOnce("?")
        let withoutGETParameters = split1 == nil ? url : split1!.0
        
        let components = withoutGETParameters.split("/")
        guard components.count == elements.count else { return (false, [:]) }

        var params : [String: String] = [:]
        
        for i in 0 ..< components.count {
            
            let string = components[i]
            let pattern = elements[i]
    
            guard pattern.matches(string) else { return (false, [:]) }
            
            if case .Parameter(let name, _) = pattern {
                params[name] = string
            }
        }

        return (true, params)
    }
}


