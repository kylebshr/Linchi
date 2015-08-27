//
//  FileReader.swift
//  Linchi
//

import Darwin

/// Returns the content of the file situated at `path` or `nil` if an error occured.
public func readFile(path: String) -> [UInt8]? {
    
    let file = fopen(path, "r")
    guard file != nil else { return nil }
    
    var bytes = [UInt8]()
    var c = fgetc(file)
    
    while c != EOF {
        bytes.append(UInt8(c))
        c = fgetc(file)
    }
    
    return bytes
}

