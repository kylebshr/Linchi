//
//  HTTPMessage.swift
//  Linchi
//

internal struct HTTPMessage {
    
    let startLine : String
    
    let headers : [String : String]
    
    let body : String
}