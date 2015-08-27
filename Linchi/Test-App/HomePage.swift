//
//  HomePage.swift
//  Linchi
//

import Darwin

struct HomePage {

    static func getMainPage(request: HTTPRequest) -> HTTPResponse {
        
        guard let data = DEMO_SERVER.cachedFiles["static/index.html"] else {
            return DEMO_SERVER.defaultResponseWriters.notFound(request)
        }

        return BasicResponseWriters.sendData(data)(request)
    }
    
    static func greetFriend(request: HTTPRequest) -> HTTPResponse {
        
        guard let greeter = request.urlParameters["greeter"] else {
            return DEMO_SERVER.defaultResponseWriters.notFound(request)
        }
    
        let message : String
        if let greetee = request.methodParameters["greetee"] {
            message = greeter + " says hello to " + greetee + "!"
        }
        else {
            message = greeter + " doesn’t like to say hello."
        }

        let html =
        "<html><head><link rel='stylesheet' type='text/css' href='/static/style.css'></head>" +
        "<body><h3>" + message + "</h3></body></html>"
        
        return HTTPResponse(body: html)
    }

}

