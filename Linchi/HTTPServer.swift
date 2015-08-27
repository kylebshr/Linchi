//
//  HTTPServer.swift
//  Linchi
//

import Darwin

// TODO: document it

public class HTTPServer {

    public var defaultResponseWriters = DefaultResponseWriters()
    // Replace with URLRouter once it is implemented
    internal var router : [Page] = []
    private var passiveSocket = PassiveSocket.defaultInvalidSocket()

    /// Start the server at the given port (default: 8080)
    public func start(port: in_port_t = 8080) {

        passiveSocket = PassiveSocket(listeningToPort: port)!
        print("Server started.")

        while let activeSocket = ActiveSocket(fromPassiveSocket: passiveSocket) {
            // TODO: do this asynchronously
            self.handleSocket(activeSocket)
        }
        stop()
    }

    private func handleSocket(activeSocket: ActiveSocket) {
        
        while let message = activeSocket.nextMessage(), let request = parseRequest(message) {

            // TODO: do the entire body of the loop asynchronously
            
            // I don't like the keepAlive constant. Would be nice to find an other way to deal with it.
            // For now, it is always false because keeping alive a connection without
            // having implemented concurrency can block other connections.
            let keepAlive = false //request.headers["connection"] == "keep-alive"

            guard let (writeResponse, params) = findResponseWriterAndURLParameters(request.method, url: request.url) else {
                activeSocket.respond(defaultResponseWriters.notFound(request), keepAlive: keepAlive)
                if keepAlive { continue } else { break }
            }

            // I also don't like that the request has to be updated.
            // Would be nice to include `params` in the request directly
            let updatedRequest = HTTPRequest(
                method           : request.method,
                url              : request.url,
                headers          : request.headers,
                body             : request.body,
                methodParameters : request.methodParameters,
                urlParameters    : params
            )

            activeSocket.respond(writeResponse(updatedRequest), keepAlive: keepAlive)

            if !keepAlive { break }
        }

        activeSocket.release()
    }


    private func findResponseWriterAndURLParameters(method: HTTPMethod, url: String) -> (ResponseWriter, [String: String])? {
        
        let urlString = url.newByReplacingPlusesBySpaces().newByRemovingPercentEncoding()
        
        // In the future, all of this will be replaced by the appropriate method on a URLRouter structure
        let correctMethodPages = router.filter { $0.method == method }
        
        for page in correctMethodPages {
            let match = page.url.matches(urlString)
            if match.0 == true {
                return (page.responseWriter, match.1)
            }
        }
        return nil
    }

    /// Access or modify the url router
    public subscript (method: HTTPMethod, rawUrl: String) -> ResponseWriter? {
        get {
            return nil
        }
        set (newValue) {
            if let newHandler = newValue {
                let urlpattern = URLPattern(str: rawUrl)!
                let newPage = Page(method: method, url: urlpattern, responseWriter: newHandler)
                router.append(newPage)
            }
        }
    }

    /// Add the files in the cache to the url router of the server
    func addFiles(cache: FileCache) {
        for (url, data) in cache {
            self[.GET, url] = BasicResponseWriters.sendData(data)
        }
    }

    public func stop() {
        passiveSocket.release()
        passiveSocket = PassiveSocket.defaultInvalidSocket()
    }
    
}



