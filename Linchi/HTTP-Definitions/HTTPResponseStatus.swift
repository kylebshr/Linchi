//
//  HTTPResponseStatus.swift
//  Linchi
//

/// Enum containing all possible status for an HTTPResponse
public enum HTTPResponseStatus {
    
    // TODO: add the other status codes
    
    case OK, Created, Accepted
    case MovedPermanently(String)
    case BadRequest, Unauthorized, Forbidden, NotFound
    case InternalServerError
    case RAW(UInt)
    
    /// Returns the corresponding status code ( e.g. for `.NotFound`, returns `404` )
    public func code() -> UInt {
        switch self {
        case .OK                    : return 200
        case .Created               : return 201
        case .Accepted              : return 202
        case .MovedPermanently      : return 301
        case .BadRequest            : return 400
        case .Unauthorized          : return 401
        case .Forbidden             : return 403
        case .NotFound              : return 404
        case .InternalServerError   : return 500
        case .RAW(let code)         : return code
        }
    }
    
    /// Returns the corresponding string ( e.g. for `.BadRequest`, returns `"Bad Request"` )
    public func reason() -> String {
        switch self {
        case .OK                    : return "OK"
        case .Created               : return "Created"
        case .Accepted              : return "Accepted"
        case .MovedPermanently      : return "Moved Permanently"
        case .BadRequest            : return "Bad Request"
        case .Unauthorized          : return "Unauthorized"
        case .Forbidden             : return "Forbidden"
        case .NotFound              : return "Not Found"
        case .InternalServerError   : return "Internal Server Error"
        case .RAW(_)                : return "Custom"
        }
    }
    
    /// Returns the corresponding headers ( mainly for `.MovedPermaently`: it adds `[Location: …]` )
    internal func headers() -> [String: String] {
        
        var headers = [String: String]()

        if case .MovedPermanently(let location) = self {
            headers["Location"] = location
        }
        
        return headers
    }
}


