//
//  SocketOptions.swift
//  Linchi
//

import Darwin

/// Options that can be applied to a socket, to change its behavior
internal enum SocketOption {
    
    /// Enables local address reuse
    case LocalAddressReuse
    /// Do not generate SIGPIPE, instead return EPIPE
    case NoSigPipe // TODO: option not available on Linux, find altrenative
    /// Enables duplicate address and port bindings
    case PortReuse
    
    /// Get the corresponding constant. Allows for communication with C APIs
    var value: Int32 {
        switch self {
        case .LocalAddressReuse : return SO_REUSEADDR
        case .NoSigPipe         : return SO_NOSIGPIPE
        case .PortReuse         : return SO_REUSEPORT
        }
    }
}
