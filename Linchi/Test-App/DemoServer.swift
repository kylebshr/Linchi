//
//  DemoServer.swift
//  Linchi
//

import Darwin

let DEMO_SERVER = DemoServer()

class DemoServer : HTTPServer {
    
    let basePath : String
    var cachedFiles : FileCache

    override init() {
        
        // replace with correct path for you
        self.basePath = "\(PROJECT_DIR)/"
        self.cachedFiles = FileCache()
        
        super.init()

        try! cachedFiles.addFilesInDirectory(basePath + "static/", url: "static/")
        self.addFiles(cachedFiles)
        
        guard let page404 = cachedFiles["static/404.html"] else { fatalError() }
        self.defaultResponseWriters.notFound = BasicResponseWriters.sendData(page404)

        self[.GET, "/"] = HomePage.getMainPage
        self[.GET, "/hello/∆: greeter=\(RegEx.CharClass.Printable)+"] = HomePage.greetFriend
        self[.POST, "/hello/∆: greeter=\(RegEx.CharClass.Printable)+"] = HomePage.greetFriend
    }
    
}

