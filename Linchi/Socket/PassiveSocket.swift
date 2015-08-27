//
//  PassiveSocket.swift
//  Linchi
//

import Darwin

/// “A passive socket is not connected, but rather awaits an incoming connection, which will spawn a new active socket”
internal struct PassiveSocket : Socket {
    
    /// File Descriptor
    let fd : CInt
    
    private init(_ fd: CInt) { self.fd = fd }
    
    /// Use this when you have to create a socket and don't want to play with optionals
    static func defaultInvalidSocket() -> PassiveSocket {
        return PassiveSocket(-1)
    }
    
    /** 
    Initialize the socket by doing the following things:
    - Apply some basic options (currently LocalAddressReuse and NoSigPipe)
    - Bind it to the loopback address and given port
    - Make it listen for connections
    
    The initialization will fail and throw the appropriate SocketError if any of these steps fail.
    */
    init?(listeningToPort port: in_port_t) {

        var hints = addrinfo()
        var res = UnsafeMutablePointer<addrinfo>()
        
        hints.ai_family   = AF_INET6
        hints.ai_socktype = SOCK_STREAM
        hints.ai_flags    = AI_PASSIVE
        
        let stringport = String(port).utf8.map {Int8($0)} + [0]
        
        let infoSuccess = getaddrinfo(nil, stringport, &hints, &res)
        guard infoSuccess == 0 else { return nil }
        
        defer { freeaddrinfo(res) }

        for var addressPointer = res; addressPointer != nil; addressPointer = addressPointer.memory.ai_next {
            
            let address = addressPointer.memory
            let sockfd = socket(address.ai_family, address.ai_socktype, address.ai_protocol)
            
            let sock = PassiveSocket(sockfd)
            
            do {
                try sock.applyOptions(.LocalAddressReuse, .NoSigPipe)
                try sock.bindToAddress(address)
                try sock.listenToMaxPendingConnections(20)
                self = sock
                return
            }
            catch SocketError.CannotSetOption(option: let opt) { print("Cannot set option: \(opt)") }
            catch SocketError.BindFailed                       { print("Bind failed")}
            catch SocketError.ListenFailed                     { print("Listen failed") }
            catch {
                print("Could not create passive socket for unknown reasons")
            }
        }

        return nil
    }
    
    private func bindToAddress(addr: addrinfo) throws {
        let bindSuccess = bind(fd, addr.ai_addr, addr.ai_addrlen)
        guard bindSuccess != -1 else { throw SocketError.BindFailed }
    }

    private func listenToMaxPendingConnections(p: Int32) throws {
        let success = listen(fd, p)
        if success == -1 { throw SocketError.ListenFailed }
    }
}



