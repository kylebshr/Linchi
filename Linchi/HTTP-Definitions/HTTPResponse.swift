//
//  HTTPResponse.swift
//  Linchi
//

/// Structure describing an HTTP response
public struct HTTPResponse {
    
    /// Status of the response ( e.g. `OK` or `NotFound` )
    public let status : HTTPResponseStatus
    
    /// Additional headers
    public let headers : [String: String]
    
    /// Body of the response ( e.g. the content of a webpage )
    public let body : [UInt8]

    
    public init(status: HTTPResponseStatus = .OK, headers: [String: String] = [:], body: [UInt8] = []) {
        self.status = status
        self.headers = headers
        self.body = body
    }
    
    public init(_ status: HTTPResponseStatus = .OK, headers: [String: String] = [:], body: String = "") {
        self.status = status
        self.headers = headers
        self.body = body.toUTF8Bytes()
    }
}
