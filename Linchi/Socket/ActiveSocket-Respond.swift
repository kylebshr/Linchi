//
//  ActiveSocket-Respond.swift
//  Linchi
//

import Darwin

extension ActiveSocket {
    
    /// Sends the HTTPResponse to the receiver of the socket
    func respond(response: HTTPResponse, keepAlive: Bool) {
    
        var content = ""
        content += "HTTP/1.1 \(response.status.code()) \(response.status.reason())\r\n"
        content += "Server: Linchi\r\n"

        if keepAlive { content += "Connection: keep-alive\r\n" }

        for (name, value) in response.status.headers() {
            content += "\(name): \(value)\r\n"
        }
        for (name, value) in response.headers {
            content += "\(name): \(value)\r\n"
        }

        content += "Content-Length: \(response.body.count)\r\n"
        
        content += "\r\n"
        
        do {
            try writeData(content.toUTF8Bytes())
            try writeData(response.body)
        }
        catch ActiveSocket.Error.WriteFailed {
            print("could not respond because send() failed")
            release()
        }
        catch { fatalError("writeData can only throw SocketError.WriteFailed") }
    }


    /// Sends the given data to the receiver of the socket
    func writeData(data: [UInt8]) throws {

        var sent = 0
        let dataBuffer = UnsafePointer<UInt8>(data)
        
        while sent < data.count {
            let sentBytes = send(fd, dataBuffer + sent, Int(data.count - sent), 0)
            guard sentBytes != -1 else { throw ActiveSocket.Error.WriteFailed }
            sent += sentBytes
        }
    }

}

