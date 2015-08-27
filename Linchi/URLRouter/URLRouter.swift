//
//  URLRouter.swift
//  Linchi
//

// TODO: implement a structure conforming to this protocol
// There is no need to keep this protocol around after creating the structure
protocol URLRouter {

    // The complexity of these two methods should be almost independant from the number of urls inside the router.
    // (Try a trie)
    // 
    // Once implemented, URLRouter should render `Page` useless.
    
    // Associate the given ResponseWriter to the url and method
    func add(method: HTTPMethod, url: String, rw: ResponseWriter)
    
    // Find the ResponseWriter associated with the string and method and
    // return the parameters, if any, included in the url
    func get(method: HTTPMethod, url: String) -> (rw: ResponseWriter, params: [String: String])
}


