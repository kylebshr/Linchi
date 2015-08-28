//
//  ActiveSocket-Receive.swift
//  Linchi
//

import Darwin

extension ActiveSocket {
 
    /// Returns the address of the peer connected to the socket
    func peername() -> String? {
        
        var addr = sockaddr()
        var len: socklen_t = socklen_t(sizeof(sockaddr))
        
        guard getpeername(fd, &addr, &len) == 0 else { return nil }
        var hostBuffer = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
        
        guard getnameinfo(&addr, len, &hostBuffer, socklen_t(hostBuffer.count), nil, 0, NI_NUMERICHOST) == 0 else { return nil }
        
        return String.fromUTF8Bytes(hostBuffer.map { UInt8($0) })
    }

    /// Receives a whole HTTP message. This is a blocking method.
    func nextMessage() -> HTTPMessage? {
        
        guard let statusLine = nextLine() else { return nil }
        guard let headers = nextHeaders() else { return nil }

        let body : String
        if let contentLength = headers["content-length"], let contentLengthValue = UInt(contentLength) {
            body = (try? nextBody(Int(contentLengthValue))) ?? ""
        }
        else {
            body = ""
        }

        
        return HTTPMessage(startLine: statusLine, headers: headers, body: body)
    }

    
    
    /// Receives a byte
    private func nextUInt8() -> (success: Bool, value: UInt8) {
        var buffer : UInt8 = 0
        let next = recv(fd, &buffer, 1, 0)
        return (next > 0, buffer)
    }
    
    /// Receives a line
    private func nextLine() -> String? {
        var line = ""
        var n : UInt8 = 0, success = true, newLine : UInt8 = 10, carriageReturn : UInt8 = 13
        
        while success && n != newLine {
            (success, n) = nextUInt8()
            if n > carriageReturn {
                line += String(UnicodeScalar(n))
            }
        }
        guard success || !line.isEmpty else { return nil }
        
        return line
    }
    
    /// Receives `size` bytes and returns as String
    private func nextBody(size: Int) throws -> String {

        var received = 0
        var buffer = [UInt8](count: size, repeatedValue: 0)
        
        while received < size {
            let receivedBytes = recv(fd, &buffer, (size - received), 0)
            guard receivedBytes != -1 else { throw ActiveSocket.Error.ReceiveFailed }
            received += receivedBytes
        }
        return String.fromUTF8Bytes(buffer)
    }
    
    /// Receives headers and returns them as a Dictionary
    private func nextHeaders() -> Dictionary<String, String>? {
        
        var headers = Dictionary<String, String>()
        
        while let headerLine = nextLine() {
            
            if headerLine.isEmpty {
                return headers
            }
            let headerTokens = headerLine.split(":")
            
            guard headerTokens.count == 2 else { continue }
            
            // RFC 2616 - "Hypertext Transfer Protocol -- HTTP/1.1", paragraph 4.2, "Message Headers":
            let headerName = headerTokens[0].lowercaseString
            let headerValue = headerTokens[1].newByTrimmingCharactersContainedInString(" \n")
            
            if !headerName.isEmpty && !headerValue.isEmpty {
                headers.updateValue(headerValue, forKey: headerName)
            }
            
        }
        return nil
    }
    
 
}
