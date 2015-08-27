//
//  HTTPRequest2.swift
//  Linchi
//

public struct HTTPRequest : CustomStringConvertible {

    
    /// The method used for the request ( e.g. `GET`, `POST`, … )
    public let method: HTTPMethod
    
    /// The complete url of the request ( e.g. `/people/lucy/` )
    public let url: String

    /** Headers of the request
    
    __Exemple__
    
    `["cache-control" : "max-age=0", "user-agent" : "Mozilla/…", ]`
    */
    public let headers: [String: String]
    
    /// Body of the request ( e.g. content of a POST request )
    public let body: String
    
    
    // ##### Computed properties of the request #####
    
    /**
    The parameters sent with the request
    
    __Example__
    
    If the method is GET and the url is `/people/lucy/?show=friends&layout=big/`
    
    Then `requestParameters` should be `["show" : "friends", "layout" : "big"]`.
    
    Should work with POST and other methods too.
    */
    public let methodParameters: [String: String]
    
    /**
    Captures the strings matching the parameters in the URLPattern corresponding to the url of the request.
    
    __Example:__
    
    If one of the URLPattern of the server is `"people/∆: [a-z]+"`
    
    And the url of the request is `"people/lucy"`
    
    Then urlParameters should be `["lucy"]`
    */
    public let urlParameters: [String: String]

    /// A human readable description of the request
    public var description : String {
        var s : String = ""
        s += "method: \(method)\n"
        s += "url: \(url)\n"
        s += "headers: \(headers)\n"
        s += "body: \(body)\n"
        s += "method parameters: \(methodParameters)\n"
        s += "url parameters: \(urlParameters)\n"
        return s
    }
}

