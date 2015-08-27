//
//  ResponseWriter.swift
//  Linchi
//

/// A ResponseWriter defines what the server should respond depending on the request
 public typealias ResponseWriter = HTTPRequest -> HTTPResponse
