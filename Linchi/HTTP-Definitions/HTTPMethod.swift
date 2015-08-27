//
//  HTTPMethod.swift
//  Linchi
//

/// Enum describing an HTTPMethod
public enum HTTPMethod {
    
    // TODO: add the other methods
    case GET, POST

    /// Returns the correct HTTPMethod that matches the given string
    internal static func fromString(str: String) -> HTTPMethod? {
        switch str.uppercaseString {
        case "GET" : return .GET
        case "POST": return .POST
        default    : return nil
        }
    }
}