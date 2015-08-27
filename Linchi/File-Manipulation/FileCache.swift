//
//  FileCache.swift
//  Linchi
//

import Darwin

// TODO: find better name
/// A FileCache stores the content of some files in memory for fast retrieval.
public struct FileCache : SequenceType {
    
    private var allFiles : [String: [UInt8]] = [:]
    
    /// Add a file to `self`
    public mutating func addFile(path: String, url: String) {
        allFiles[url] = readFile(path)!
    }
    
    /// Add all the files in the directory to the server. This is not recursive.
    public mutating func addFilesInDirectory(path: String, url: String) throws {
        let dir = opendir(path)
        guard dir != nil else { throw Error.CannotOpenDirectory }
        defer { closedir(dir) }

        for var ent = readdir(dir); ent != nil; ent = readdir(dir) {
            
            let info = ent.memory

            var name : [Int8] = []
            let mirror = Mirror(reflecting: info.d_name)
            loop: for (_, value) in mirror.children {
                let x = value as! Int8
                if x <= 0 { break loop }
                name.append(x)
            }
            let fileName = String.fromUTF8Bytes(name.map { UInt8($0) })
            guard !fileName.hasPrefix(".") else { continue }
            let filePath = path + fileName

            if Int32(info.d_type) == DT_REG {
                allFiles[url + fileName] = readFile(filePath)!
            }
        }
    }
    
    public func generate() -> DictionaryGenerator<String, [UInt8]> {
        return allFiles.generate()
    }
    
    public subscript(url: String) -> [UInt8]? {
        get           { return allFiles[url] }
        set(newValue) { allFiles[url] = newValue }
    }

    public enum Error : ErrorType {
        case CannotOpenDirectory
    }
}


