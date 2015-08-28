//
//  Socket.swift
//  Linchi
//

import Darwin

/// “A socket is a network communications endpoint. The analogy is to a wire (the network data connection) being plugged into a socket.”
internal protocol Socket : Hashable {

    /// File Descriptor
    var fd : CInt { get }
    
    /// Apply the given options to the socket (to change its behavior)
    func applyOptions(opts: SocketOption...) throws
    
    /// Shuts down all connections associated with the socket and closes it
    func release()
}

extension Socket {
    
    func applyOptions(opts: SocketOption...) throws {
        for opt in opts {
            var flag : Int32 = 1
            let success = setsockopt(fd, SOL_SOCKET, opt.value, &flag, socklen_t(sizeof(Int32)))
            guard success != -1 else {
                throw SocketError.CannotSetOption(option: opt)
            }
        }
    }

    func release() {
        close(fd)
    }
}

enum SocketError : ErrorType {
    case CannotSetOption(option: SocketOption)
}

extension Socket {
    internal var hashValue : Int { return fd.hashValue }
}
func == <T : Socket> (lhs: T, rhs: T) -> Bool { return lhs.fd == rhs.fd }

