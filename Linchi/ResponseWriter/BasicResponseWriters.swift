//
//  Common-ResponseWriters.swift
//  Linchi
//

public struct BasicResponseWriters {

    /**
    Returns `OK` with the content of the file in the body.
    
    or `NotFound` if an error occured opening the file
    */
    static func displayFile(atPath path: String, notFoundRW: ResponseWriter) -> ResponseWriter {
        return { request in
            guard let content = readFile(path) else { return notFoundRW(request) }
            return HTTPResponse(status: .OK, body: content)
        }
    }

    /// Always returns `OK` with `data` in the body
    static func sendData(data: [UInt8]) -> ResponseWriter {
        return { request in return HTTPResponse(status: .OK, body: data) }
    }
}
