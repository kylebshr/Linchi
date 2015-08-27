//
//  HTTPParser.swift
//  Linchi
//

// TODO: document this

internal func parseRequest(message: HTTPMessage) -> HTTPRequest? {
    
    let statusTokens = message.startLine.split(" ")
    print(statusTokens)
    
    guard statusTokens.count == 3 else { return nil }
    guard let method = HTTPMethod.fromString(statusTokens.first!) else { return nil }
    guard statusTokens.last!.uppercaseString == "HTTP/1.1" else { return nil }

    let path = statusTokens[1]
    
    var requestParameters : [String: String] = [:]
    if method == .GET {
        if path.contains("?"), let query = path.split("?").last {
            requestParameters = extractParameters(query)
        }
    }

    if method == .POST, let contentType = message.headers["content-type"] {
        if contentType.lowercaseString == "application/x-www-form-urlencoded" {
            requestParameters = extractParameters(message.body)
        }
    }

    return HTTPRequest(
        method           : method,
        url              : path,
        headers          : message.headers,
        body             : message.body,
        methodParameters : requestParameters,
        urlParameters    : [:]
    )
}

/**
Given a string of type "application/x-www-form-urlencoded", 
this function extracts the keys and values of the parameters and puts them in a dictionary.

__Example__

input: `"show=friends&layout=big/"`

output: `["show": "friends", "layout": "big"]`
*/
internal func extractParameters(body: String) -> [String : String] {
    
    let splitted = body.split("&")
    
    var results : [String : String] = [:]
    
    for component in splitted {
        let tokens = component.split("=")
        guard tokens.count >= 2 else { continue }
        let t1 = tokens[0].newByReplacingPlusesBySpaces().newByRemovingPercentEncoding()
        let t2 = tokens[1].newByReplacingPlusesBySpaces().newByRemovingPercentEncoding()
        results[t1] = t2
    }
    
    return results
}

